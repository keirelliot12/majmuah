import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as location_package;

import '../../../../../app/utils/constants.dart';
import '../../../../../di/di.dart';
import '../../../../../data/network/network_info.dart';
import '../../../../../domain/models/prayer_timings/prayer_timings_model.dart';
import '../../../../../domain/usecase/get_prayer_timings_usecase.dart';

part 'prayer_timings_state.dart';

class PrayerTimingsCubit extends Cubit<PrayerTimingsState> {
  static const (String, String) _defaultLocation = ("Gresik", "Indonesia");

  final GetPrayerTimingsUseCase _getPrayerTimingsUseCase =
      instance<GetPrayerTimingsUseCase>();
  final NetworkInfo networkInfo = instance<NetworkInfo>();

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
    var formatter = DateFormat("dd-MM-yyy");
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
        prayerTimingsModel = PrayerTimingsModel(
          code: l.code!,
          status: l.message,
          data: null,
        );
        emit(GetPrayerTimesErrorState(l.message));
      },
      (r) {
        prayerTimingsModel = r;
        emit(GetPrayerTimesSuccessState(r));
      },
    );
    // return prayerTimingsModel;
  }
}
