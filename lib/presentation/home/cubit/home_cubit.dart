import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as location_package;

import '../../../app/utils/app_prefs.dart';
import '../../../app/utils/constants.dart';
import '../../../di/di.dart';
import '../../../../../app/resources/resources.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final AppPreferences _preferences = instance<AppPreferences>();

  HomeCubit() : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of(context);

  int currentIndex = Constants.quranIndex;

  void changeBotNavIndex(int index) {
    currentIndex = index;
    emit(HomeChangeBotNavIndexState());
  }

  bool darkModeOn(BuildContext context) {
    final currentThemeMode = _preferences.getAppTheme();
    return currentThemeMode == ThemeMode.dark;
  }

  void changeAppTheme(BuildContext context) {
    _preferences.changeAppTheme();
    Phoenix.rebirth(context);
    emit(HomeChangeAppThemeState());
  }

  void changeAppLanguage(BuildContext context) {
    _preferences.changeAppLanguage();
    Phoenix.rebirth(context);
    emit(HomeChangeAppLanguageState());
  }

  bool isPageBookMarked(int quranPageNumber) {
    return _preferences.isPageBookMarked(quranPageNumber);
  }

  Future<bool> isThereABookMarked() async {
    await _preferences
        .isThereABookMarked()
        .then((value) => isThereABookMarkedPage = value);
    emit(CheckQuranBookMarkPageState());
    return isThereABookMarkedPage;
  }

  Future<void> bookMarkPage(int quranPageNumber) async {
    if (!isPageBookMarked(quranPageNumber)) {
      _preferences.bookMarkPage(quranPageNumber);
    } else {
      _preferences.removeBookMarkPage();
    }
    await isThereABookMarked();
    emit(QuranBookMarkPageState());
  }

  int? bookMarkedPage;

  int? getBookMarkPage() {
    bookMarkedPage = _preferences.getBookMarkedPage();
    emit(GetQuranBookMarkPageState());
    return bookMarkedPage;
  }

  location_package.Location location = location_package.Location();

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
          // Use fallback location: Gresik, Indonesia
          print('Location service disabled - Using fallback location (Gresik, Indonesia)');
          recordLocation = ("Gresik", "Indonesia");
          emit(GetLocationSuccessState());
          return;
        }
      }

      // Try to check permission, but handle web platform gracefully
      try {
        permissionGranted = await location.hasPermission();
        if (permissionGranted == location_package.PermissionStatus.denied) {
          permissionGranted = await location.requestPermission();
          if (permissionGranted != location_package.PermissionStatus.granted) {
            // Use fallback location: Gresik, Indonesia
            print('Location permission denied - Using fallback location (Gresik, Indonesia)');
            recordLocation = ("Gresik", "Indonesia");
            emit(GetLocationSuccessState());
            return;
          }
        }
      } catch (permissionError) {
        // On web, permission check might fail, but we can still try to get location
        print('Permission check not supported on this platform: $permissionError');
        // Try to get location anyway, if it fails, outer catch will handle it
      }

      locationData = await location.getLocation();
    } catch (e) {
      print('Error getting location: $e - Using fallback location (Gresik, Indonesia)');
      // Use fallback location: Gresik, Indonesia
      recordLocation = ("Gresik", "Indonesia");
      emit(GetLocationSuccessState());
      return;
    }

    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(
          locationData.latitude!, locationData.longitude!);

      if (placeMarks.isNotEmpty) {
        recordLocation = (
          placeMarks[0].subAdministrativeArea.toString(),
          placeMarks[0].country.toString()
        );
        emit(GetLocationSuccessState());
      } else {
        // Fallback to Gresik if reverse geocoding fails
        print('No placemarks found - Using fallback location (Gresik, Indonesia)');
        recordLocation = ("Gresik", "Indonesia");
        emit(GetLocationSuccessState());
      }
    } catch (e) {
      // Fallback to Gresik if geocoding fails
      print('Error reverse geocoding: $e - Using fallback location (Gresik, Indonesia)');
      recordLocation = ("Gresik", "Indonesia");
      emit(GetLocationSuccessState());
    }
  }
}
