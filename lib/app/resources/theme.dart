import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'font_manager.dart';
import 'values.dart';

class AppColors {
  // Primary gradient (Fajr)
  static const Color lemonYellow = Color(0xFFF4F878);
  static const Color lemonGreen = Color(0xFFB8CF70);
  static const Color tealGreen = Color(0xFF00897B);
  static const Color islamicTeal = Color(0xFF2F9E84);

  // Accent / text
  static const Color darkTeal = Color(0xFF00695C);
  static const Color darkerTeal = Color(0xFF004D40);

  // Surfaces
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF7F7F2);

  // Neutrals
  static const Color gray = Color(0xFF9E9E9E);
  static const Color black = Color(0xFF111111);

  // Menu item colors (matching reference design)
  static const Color emerald500 = Color(0xFF10B981);
  static const Color amber500 = Color(0xFFF59E0B);
  static const Color indigo500 = Color(0xFF6366F1);
  static const Color rose500 = Color(0xFFF43F5E);
  static const Color orange500 = Color(0xFFF97316);
  static const Color teal600 = Color(0xFF0D9488);
  static const Color cyan600 = Color(0xFF0891B2);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color blue500 = Color(0xFF3B82F6);
}

const String kUiFontFamily = 'Poppins';
const String kArabicFontFamilyPlaceholder = 'UthmanTN';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  fontFamily: kUiFontFamily,
  scaffoldBackgroundColor: AppColors.offWhite,
  primaryColor: AppColors.tealGreen,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.tealGreen,
    onPrimary: AppColors.white,
    secondary: AppColors.lemonGreen,
    onSecondary: AppColors.darkerTeal,
    error: Colors.red,
    onError: AppColors.white,
    surface: AppColors.offWhite,
    onSurface: AppColors.darkerTeal,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    iconTheme: const IconThemeData(color: AppColors.darkerTeal),
    titleTextStyle: TextStyle(
      fontFamily: kUiFontFamily,
      fontSize: FontSize.s18,
      fontWeight: FontWeightsManager.semiBold,
      color: AppColors.darkerTeal,
    ),
  ),
  cardTheme: CardThemeData(
    color: AppColors.white,
    elevation: AppSize.s4.r,
    shadowColor: Colors.black.withAlpha(25),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSize.s16.r),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.white,
    contentPadding: EdgeInsets.all(AppPadding.p16.w),
    hintStyle: TextStyle(
      fontFamily: kUiFontFamily,
      color: AppColors.gray,
      fontSize: FontSize.s14,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSize.s12.r),
      borderSide: BorderSide.none,
    ),
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s32,
      fontWeight: FontWeightsManager.bold,
      color: AppColors.darkerTeal,
    ),
    displayMedium: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s28,
      fontWeight: FontWeightsManager.bold,
      color: AppColors.darkerTeal,
    ),
    displaySmall: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s24,
      fontWeight: FontWeightsManager.bold,
      color: AppColors.darkerTeal,
    ),
    headlineLarge: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s22,
      fontWeight: FontWeightsManager.semiBold,
      color: AppColors.darkerTeal,
    ),
    headlineMedium: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s20,
      fontWeight: FontWeightsManager.semiBold,
      color: AppColors.darkerTeal,
    ),
    headlineSmall: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s18,
      fontWeight: FontWeightsManager.semiBold,
      color: AppColors.darkerTeal,
    ),
    titleLarge: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s18,
      fontWeight: FontWeightsManager.medium,
      color: AppColors.darkTeal,
    ),
    titleMedium: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s16,
      fontWeight: FontWeightsManager.medium,
      color: AppColors.darkTeal,
    ),
    titleSmall: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s14,
      fontWeight: FontWeightsManager.medium,
      color: AppColors.darkTeal,
    ),
    bodyLarge: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s16,
      fontWeight: FontWeightsManager.regular,
      color: AppColors.darkerTeal,
    ),
    bodyMedium: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s14,
      fontWeight: FontWeightsManager.regular,
      color: AppColors.darkerTeal,
    ),
    bodySmall: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s12,
      fontWeight: FontWeightsManager.regular,
      color: AppColors.gray,
    ),
    labelLarge: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s14,
      fontWeight: FontWeightsManager.medium,
      color: AppColors.tealGreen,
    ),
    labelMedium: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s12,
      fontWeight: FontWeightsManager.medium,
      color: AppColors.tealGreen,
    ),
    labelSmall: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s10,
      fontWeight: FontWeightsManager.regular,
      color: AppColors.gray,
    ),
  ),
);

ThemeData getApplicationLightTheme() => lightTheme;

ThemeData getApplicationLDarkTheme() => lightTheme;

