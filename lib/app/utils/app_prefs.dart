import 'package:flutter/material.dart';
import 'package:annibros/app/utils/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../di/di.dart';
import '../resources/resources.dart';

const String prefsLangKey = "LANG_KEY";
const String themeModeKey = "THEME_MODE_KEY";
const String bookMarkPageKey = "BOOK_MARK_PAGE_KEY";
const String bookMarkPageBoolKey = "BOOK_MARK_PAGE_BOOL_KEY";
const String searchHistoryKey = "SEARCH_HISTORY_KEY";
const String arabicReadingFontScaleKey = "ARABIC_READING_FONT_SCALE_KEY";
const String arabicReadingFontFamilyKey = "ARABIC_READING_FONT_FAMILY_KEY";
const String readingNightModeKey = "READING_NIGHT_MODE_KEY";

const double minArabicReadingFontScale = 0.8;
const double maxArabicReadingFontScale = 1.4;
const double defaultArabicReadingFontScale = 1.0;
const String defaultArabicReadingFontFamily = FontConstants.uthmanTNFontFamily;

class AppPreferences {
  final SharedPreferences _preferences = instance<SharedPreferences>();

  AppPreferences();

  Future<String> getAppLanguage() async {
    String? language = _preferences.getString(prefsLangKey);
    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      // Default ke Indonesia (menggunakan en.json yang berisi terjemahan Indonesia)
      return LanguageType.english.getValue();
    }
  }

  Future changeAppLanguage() async {
    String currentLanguage = await getAppLanguage();
    if (currentLanguage == LanguageType.english.getValue()) {
      _preferences.setString(prefsLangKey, LanguageType.arabic.getValue());
    } else {
      _preferences.setString(prefsLangKey, LanguageType.english.getValue());
    }
  }

  Future<Locale> getAppLocale() async {
    String currentLanguage = await getAppLanguage();
    if (currentLanguage == LanguageType.arabic.getValue()) {
      return arabicLocale;
    } else {
      return englishLocale;
    }
  }

  ThemeMode getAppTheme() {
    String? themeMode = _preferences.getString(themeModeKey);
    if (themeMode != null && themeMode.isNotEmpty) {
      if (themeMode == 'dark') {
        return ThemeMode.dark;
      } else {
        return ThemeMode.light;
      }
    } else {
      return ThemeMode.light;
    }
  }

  void changeAppTheme() {
    ThemeMode currentTheme = getAppTheme();
    if (currentTheme == ThemeMode.dark) {
      _preferences.setString(themeModeKey, 'light');
    } else {
      _preferences.setString(themeModeKey, 'dark');
    }
  }

  Future<void> bookMarkPage(int quranPageNumber) async {
    await _preferences
        .setInt(bookMarkPageKey, quranPageNumber)
        .then((value) => _preferences.setBool(bookMarkPageBoolKey, true));
  }

  Future<void> removeBookMarkPage() async {
    await _preferences
        .remove(bookMarkPageKey)
        .then((value) => _preferences.setBool(bookMarkPageBoolKey, false));
  }

  int? getBookMarkedPage() {
    return _preferences.getInt(bookMarkPageKey);
  }

  bool isPageBookMarked(int quranPageNumber) {
    return quranPageNumber == _preferences.getInt(bookMarkPageKey);
  }

  Future<bool> isThereABookMarked() async {
    return _preferences.getBool(bookMarkPageBoolKey).orFalse();
  }

  // --- Search History ---

  List<String> getSearchHistory() {
    return _preferences.getStringList(searchHistoryKey) ?? [];
  }

  Future<void> addSearchQuery(String query) async {
    if (query.isEmpty) return;

    List<String> history = getSearchHistory();
    // Remove if already exists to move it to the front
    history.remove(query);
    history.insert(0, query);

    // Limit to 10 latest searches
    if (history.length > 10) {
      history = history.sublist(0, 10);
    }

    await _preferences.setStringList(searchHistoryKey, history);
  }

  Future<void> clearSearchHistory() async {
    await _preferences.remove(searchHistoryKey);
  }

  double getArabicReadingFontScale() {
    final storedScale =
        _preferences.getDouble(arabicReadingFontScaleKey) ??
        defaultArabicReadingFontScale;

    return storedScale
        .clamp(minArabicReadingFontScale, maxArabicReadingFontScale)
        .toDouble();
  }

  Future<void> setArabicReadingFontScale(double scale) async {
    final clampedScale = scale.clamp(
      minArabicReadingFontScale,
      maxArabicReadingFontScale,
    );

    await _preferences.setDouble(
      arabicReadingFontScaleKey,
      clampedScale.toDouble(),
    );
  }

  String getArabicReadingFontFamily() {
    final storedFamily = _preferences.getString(arabicReadingFontFamilyKey);
    if (storedFamily == FontConstants.hafsFontFamily ||
        storedFamily == FontConstants.meQuranFontFamily ||
        storedFamily == FontConstants.uthmanTNFontFamily) {
      return storedFamily!;
    }
    return defaultArabicReadingFontFamily;
  }

  Future<void> setArabicReadingFontFamily(String fontFamily) async {
    await _preferences.setString(arabicReadingFontFamilyKey, fontFamily);
  }

  bool getReadingNightMode() {
    return _preferences.getBool(readingNightModeKey) ?? false;
  }

  Future<void> setReadingNightMode(bool enabled) async {
    await _preferences.setBool(readingNightModeKey, enabled);
  }
}
