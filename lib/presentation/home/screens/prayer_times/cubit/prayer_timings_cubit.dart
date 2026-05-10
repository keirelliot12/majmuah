import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as location_package;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../app/utils/constants.dart';
import '../../../../../di/di.dart';
import '../../../../../data/network/network_info.dart';
import '../../../../../domain/models/prayer_timings/prayer_timings_model.dart';
import '../../../../../domain/usecase/get_prayer_timings_usecase.dart';

part 'prayer_timings_state.dart';

class PrayerTimingsCubit extends Cubit<PrayerTimingsState> {
  static const (String, String) _defaultLocation = ("Gresik", "Indonesia");
  static const String _cacheDateKey = "prayer_timings_cache_date";
  static const String _cachePayloadKey = "prayer_timings_cache_payload";
  static const String _fallbackStatus = "Fallback Gresik";

  final GetPrayerTimingsUseCase _getPrayerTimingsUseCase =
      instance<GetPrayerTimingsUseCase>();
  final NetworkInfo networkInfo = instance<NetworkInfo>();
  final SharedPreferences _preferences = instance<SharedPreferences>();

  PrayerTimingsCubit() : super(PrayerTimesInitialState());

  static PrayerTimingsCubit get(context) => BlocProvider.of(context);

  bool isConnected = false;

  Future<void> isNetworkConnected() async {
    emit(GetConnectionLoadingState());
    await networkInfo.isConnected
        .then((value) {
          isConnected = value;
          emit(GetConnectionSuccessState());
        })
        .catchError((error) {
          emit(GetConnectionErrorState(error.toString()));
        });
  }

  location_package.Location location = location_package.Location();

  PrayerTimingsModel prayerTimingsModel = const PrayerTimingsModel(
    code: 0,
    status: "",
    data: null,
  );

  // (String, String) recordLocation = ("", "");

  Future<void> getLocation() async {
    emit(GetLocationLoadingState());

    bool serviceEnabled;
    location_package.PermissionStatus permissionGranted;
    location_package.LocationData locationData;

    try {
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          _useDefaultLocation();
          return;
        }
      }

      // Try to check permission, but handle web platform gracefully
      try {
        permissionGranted = await location.hasPermission();
        if (permissionGranted == location_package.PermissionStatus.denied) {
          permissionGranted = await location.requestPermission();
          if (permissionGranted != location_package.PermissionStatus.granted) {
            _useDefaultLocation();
            return;
          }
        } else if (permissionGranted ==
            location_package.PermissionStatus.deniedForever) {
          _useDefaultLocation();
          return;
        }
      } catch (_) {
        // On web, permission check might fail, but we can still try to get location
        // Try to get location anyway, if it fails, outer catch will handle it
      }

      locationData = await location.getLocation();
    } catch (e) {
      _useDefaultLocation();
      return;
    }

    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(
        locationData.latitude!,
        locationData.longitude!,
      );

      if (placeMarks.isNotEmpty) {
        recordLocation = (
          placeMarks[0].subAdministrativeArea.toString(),
          placeMarks[0].country.toString(),
        );
        emit(GetLocationSuccessState());
      } else {
        _useDefaultLocation();
      }
    } catch (e) {
      _useDefaultLocation();
    }
  }

  void _useDefaultLocation() {
    recordLocation = _defaultLocation;
    emit(GetLocationSuccessState());
  }

  Future<void> refreshPrayerTimingsWithCurrentLocation() async {
    recordLocation = ("", "");
    await getPrayerTimings(refreshLocation: true);
  }

  Future<void> getPrayerTimings({bool refreshLocation = false}) async {
    emit(GetPrayerTimesLoadingState());
    if (refreshLocation || recordLocation.$1 == "" || recordLocation.$2 == "") {
      await getLocation();
    }
    DateTime dateNow = DateTime.now();
    var formatter = DateFormat("dd-MM-yyyy");
    String formattedDate = formatter.format(dateNow);
    final result = await _getPrayerTimingsUseCase(
      GetPrayerTimingsUseCaseUseCaseInput(
        date: formattedDate,
        city: recordLocation.$1,
        country: recordLocation.$2,
      ),
    );
    result.fold(
      (l) {
        final cachedModel = _loadCachedPrayerTimings(formattedDate);
        prayerTimingsModel =
            cachedModel ?? _buildFallbackPrayerTimings(dateNow);
        emit(GetPrayerTimesSuccessState(prayerTimingsModel));
      },
      (r) {
        prayerTimingsModel = r;
        _cachePrayerTimings(formattedDate, r);
        emit(GetPrayerTimesSuccessState(r));
      },
    );
    // return prayerTimingsModel;
  }

  void _cachePrayerTimings(String formattedDate, PrayerTimingsModel model) {
    final payload = _prayerTimingsToJson(model);
    if (payload == null) return;

    _preferences.setString(_cacheDateKey, formattedDate);
    _preferences.setString(_cachePayloadKey, jsonEncode(payload));
  }

  PrayerTimingsModel? _loadCachedPrayerTimings(String formattedDate) {
    if (_preferences.getString(_cacheDateKey) != formattedDate) return null;

    final rawPayload = _preferences.getString(_cachePayloadKey);
    if (rawPayload == null || rawPayload.isEmpty) return null;

    try {
      final decoded = jsonDecode(rawPayload);
      if (decoded is! Map<String, dynamic>) return null;
      return _prayerTimingsFromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic>? _prayerTimingsToJson(PrayerTimingsModel model) {
    final timings = model.data?.timings;
    final date = model.data?.date;
    final hijri = date?.hijri;
    final gregorian = date?.gregorian;

    if (timings == null || date == null || hijri == null || gregorian == null) {
      return null;
    }

    return {
      "code": model.code,
      "status": model.status,
      "timings": {
        "fajr": timings.fajr,
        "sunrise": timings.sunrise,
        "dhuhr": timings.dhuhr,
        "asr": timings.asr,
        "maghrib": timings.maghrib,
        "isha": timings.isha,
      },
      "date": {
        "readable": date.readable,
        "timestamp": date.timestamp,
        "hijri": _datePartToJson(hijri),
        "gregorian": _datePartToJson(gregorian),
      },
    };
  }

  PrayerTimingsModel? _prayerTimingsFromJson(Map<String, dynamic> json) {
    final timings = json["timings"];
    final date = json["date"];
    if (timings is! Map<String, dynamic> || date is! Map<String, dynamic>) {
      return null;
    }

    final hijri = date["hijri"];
    final gregorian = date["gregorian"];
    if (hijri is! Map<String, dynamic> || gregorian is! Map<String, dynamic>) {
      return null;
    }

    return PrayerTimingsModel(
      code: json["code"] as int? ?? 200,
      status: json["status"] as String? ?? "Cached",
      data: PrayerTimingsDataModel(
        timings: TimingsModel(
          fajr: timings["fajr"] as String? ?? "04:16",
          sunrise: timings["sunrise"] as String? ?? "05:29",
          dhuhr: timings["dhuhr"] as String? ?? "11:34",
          asr: timings["asr"] as String? ?? "14:55",
          maghrib: timings["maghrib"] as String? ?? "17:27",
          isha: timings["isha"] as String? ?? "18:38",
        ),
        date: DateModel(
          readable: date["readable"] as String? ?? "",
          timestamp: date["timestamp"] as String? ?? "",
          hijri: _hijriFromJson(hijri),
          gregorian: _gregorianFromJson(gregorian),
        ),
      ),
    );
  }

  Map<String, dynamic> _datePartToJson(dynamic datePart) {
    return {
      "date": datePart.date,
      "format": datePart.format,
      "day": datePart.day,
      "weekday": {
        "en": datePart.weekday?.en ?? "",
        "ar": datePart.weekday?.ar ?? "",
      },
      "month": {
        "number": datePart.month?.number ?? 0,
        "en": datePart.month?.en ?? "",
        "ar": datePart.month?.ar ?? "",
      },
      "year": datePart.year,
    };
  }

  HijriModel _hijriFromJson(Map<String, dynamic> json) {
    return HijriModel(
      date: json["date"] as String? ?? "",
      format: json["format"] as String? ?? "DD-MM-YYYY",
      day: json["day"] as String? ?? "",
      weekday: _weekdayFromJson(json["weekday"]),
      month: _monthFromJson(json["month"]),
      year: json["year"] as String? ?? "",
    );
  }

  GregorianModel _gregorianFromJson(Map<String, dynamic> json) {
    return GregorianModel(
      date: json["date"] as String? ?? "",
      format: json["format"] as String? ?? "DD-MM-YYYY",
      day: json["day"] as String? ?? "",
      weekday: _weekdayFromJson(json["weekday"]),
      month: _monthFromJson(json["month"]),
      year: json["year"] as String? ?? "",
    );
  }

  WeekdayModel _weekdayFromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return const WeekdayModel(en: "", ar: "");
    }
    return WeekdayModel(
      en: json["en"] as String? ?? "",
      ar: json["ar"] as String? ?? "",
    );
  }

  MonthModel _monthFromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return const MonthModel(number: 0, en: "", ar: "");
    }
    return MonthModel(
      number: json["number"] as int? ?? 0,
      en: json["en"] as String? ?? "",
      ar: json["ar"] as String? ?? "",
    );
  }

  PrayerTimingsModel _buildFallbackPrayerTimings(DateTime date) {
    final hijri = _gregorianToCivilHijri(date);
    final gregorianWeekday = _fallbackWeekdayFor(date.weekday);
    final gregorianMonth = _fallbackGregorianMonthFor(date.month);
    final hijriMonth = _fallbackHijriMonthFor(hijri.month);
    final gregorianDate = DateFormat("dd-MM-yyyy").format(date);
    final hijriDate =
        "${hijri.day.toString().padLeft(2, '0')}-${hijri.month.toString().padLeft(2, '0')}-${hijri.year}";

    return PrayerTimingsModel(
      code: 200,
      status: _fallbackStatus,
      data: PrayerTimingsDataModel(
        timings: const TimingsModel(
          fajr: "04:16",
          sunrise: "05:29",
          dhuhr: "11:34",
          asr: "14:55",
          maghrib: "17:27",
          isha: "18:38",
        ),
        date: DateModel(
          readable: gregorianDate,
          timestamp: date.millisecondsSinceEpoch.toString(),
          hijri: HijriModel(
            date: hijriDate,
            format: "DD-MM-YYYY",
            day: hijri.day.toString().padLeft(2, '0'),
            weekday: gregorianWeekday,
            month: hijriMonth,
            year: hijri.year.toString(),
          ),
          gregorian: GregorianModel(
            date: gregorianDate,
            format: "DD-MM-YYYY",
            day: date.day.toString().padLeft(2, '0'),
            weekday: gregorianWeekday,
            month: gregorianMonth,
            year: date.year.toString(),
          ),
        ),
      ),
    );
  }

  ({int day, int month, int year}) _gregorianToCivilHijri(DateTime date) {
    final a = (14 - date.month) ~/ 12;
    final y = date.year + 4800 - a;
    final m = date.month + (12 * a) - 3;
    final julianDay =
        date.day +
        (((153 * m) + 2) ~/ 5) +
        (365 * y) +
        (y ~/ 4) -
        (y ~/ 100) +
        (y ~/ 400) -
        32045;

    var l = julianDay - 1948440 + 10632;
    final n = (l - 1) ~/ 10631;
    l = l - (10631 * n) + 354;
    final j =
        (((10985 - l) ~/ 5316) * ((50 * l) ~/ 17719)) +
        ((l ~/ 5670) * ((43 * l) ~/ 15238));
    l =
        l -
        (((30 - j) ~/ 15) * ((17719 * j) ~/ 50)) -
        ((j ~/ 16) * ((15238 * j) ~/ 43)) +
        29;
    final month = (24 * l) ~/ 709;
    final day = l - ((709 * month) ~/ 24);
    final year = (30 * n) + j - 30;

    return (day: day, month: month, year: year);
  }

  WeekdayModel _fallbackWeekdayFor(int weekday) {
    const weekdays = [
      WeekdayModel(en: "Monday", ar: "Monday"),
      WeekdayModel(en: "Tuesday", ar: "Tuesday"),
      WeekdayModel(en: "Wednesday", ar: "Wednesday"),
      WeekdayModel(en: "Thursday", ar: "Thursday"),
      WeekdayModel(en: "Friday", ar: "Friday"),
      WeekdayModel(en: "Saturday", ar: "Saturday"),
      WeekdayModel(en: "Sunday", ar: "Sunday"),
    ];
    return weekdays[weekday - 1];
  }

  MonthModel _fallbackGregorianMonthFor(int month) {
    const months = [
      MonthModel(number: 1, en: "January", ar: "January"),
      MonthModel(number: 2, en: "February", ar: "February"),
      MonthModel(number: 3, en: "March", ar: "March"),
      MonthModel(number: 4, en: "April", ar: "April"),
      MonthModel(number: 5, en: "May", ar: "May"),
      MonthModel(number: 6, en: "June", ar: "June"),
      MonthModel(number: 7, en: "July", ar: "July"),
      MonthModel(number: 8, en: "August", ar: "August"),
      MonthModel(number: 9, en: "September", ar: "September"),
      MonthModel(number: 10, en: "October", ar: "October"),
      MonthModel(number: 11, en: "November", ar: "November"),
      MonthModel(number: 12, en: "December", ar: "December"),
    ];
    return months[month - 1];
  }

  MonthModel _fallbackHijriMonthFor(int month) {
    const months = [
      MonthModel(number: 1, en: "Muharram", ar: "Muharram"),
      MonthModel(number: 2, en: "Safar", ar: "Safar"),
      MonthModel(number: 3, en: "Rabi Al-Awwal", ar: "Rabi Al-Awwal"),
      MonthModel(number: 4, en: "Rabi Al-Thani", ar: "Rabi Al-Thani"),
      MonthModel(number: 5, en: "Jumada Al-Awwal", ar: "Jumada Al-Awwal"),
      MonthModel(number: 6, en: "Jumada Al-Thani", ar: "Jumada Al-Thani"),
      MonthModel(number: 7, en: "Rajab", ar: "Rajab"),
      MonthModel(number: 8, en: "Sha'ban", ar: "Sha'ban"),
      MonthModel(number: 9, en: "Ramadan", ar: "Ramadan"),
      MonthModel(number: 10, en: "Shawwal", ar: "Shawwal"),
      MonthModel(number: 11, en: "Dhu Al-Qadah", ar: "Dhu Al-Qadah"),
      MonthModel(number: 12, en: "Dhu Al-Hijjah", ar: "Dhu Al-Hijjah"),
    ];
    return months[month - 1];
  }
}
