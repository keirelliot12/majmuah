import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'font_manager.dart';
import 'values.dart';

class AppColors {
  // AN NIBROS brand system
  static const Color background = Color(0xFFF6F7EF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFEEF3E3);
  static const Color deepEmerald = Color(0xFF123D32);
  static const Color emerald = Color(0xFF087864);
  static const Color mutedEmerald = Color(0xFF5F766F);
  static const Color limeGold = Color(0xFFC3D654);
  static const Color warmGold = Color(0xFFB79A46);
  static const Color softBorder = Color(0xFFE0E8D5);
  static const Color softDanger = Color(0xFFB84A45);

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
  static const Color darkBackground = Color(0xFF081713);
  static const Color darkSurface = Color(0xFF10251F);
  static const Color darkSurfaceMuted = Color(0xFF17342C);
  static const Color darkText = Color(0xFFE7F0E8);
  static const Color darkTextMuted = Color(0xFFAEC6BB);

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

  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: deepEmerald.withAlpha(13),
      blurRadius: 18,
      offset: const Offset(0, 8),
    ),
  ];
}

const String kUiFontFamily = FontConstants.elMessiriFontFamily;
const String kArabicFontFamilyPlaceholder = 'UthmanTN';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  fontFamily: kUiFontFamily,
  scaffoldBackgroundColor: AppColors.background,
  primaryColor: AppColors.emerald,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.emerald,
    onPrimary: AppColors.white,
    secondary: AppColors.limeGold,
    onSecondary: AppColors.deepEmerald,
    error: AppColors.softDanger,
    onError: AppColors.white,
    surface: AppColors.surface,
    onSurface: AppColors.deepEmerald,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    iconTheme: const IconThemeData(color: AppColors.deepEmerald),
    titleTextStyle: TextStyle(
      fontFamily: kUiFontFamily,
      fontSize: FontSize.s18,
      fontWeight: FontWeightsManager.semiBold,
      color: AppColors.deepEmerald,
    ),
  ),
  cardTheme: CardThemeData(
    color: AppColors.surface,
    elevation: 0,
    shadowColor: AppColors.deepEmerald.withAlpha(14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSize.s18.r),
      side: const BorderSide(color: AppColors.softBorder),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface,
    contentPadding: EdgeInsets.all(AppPadding.p16.w),
    hintStyle: TextStyle(
      fontFamily: kUiFontFamily,
      color: AppColors.mutedEmerald,
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
      color: AppColors.deepEmerald,
    ),
    displayMedium: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s28,
      fontWeight: FontWeightsManager.bold,
      color: AppColors.deepEmerald,
    ),
    displaySmall: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s24,
      fontWeight: FontWeightsManager.bold,
      color: AppColors.deepEmerald,
    ),
    headlineLarge: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s22,
      fontWeight: FontWeightsManager.semiBold,
      color: AppColors.deepEmerald,
    ),
    headlineMedium: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s20,
      fontWeight: FontWeightsManager.semiBold,
      color: AppColors.deepEmerald,
    ),
    headlineSmall: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s18,
      fontWeight: FontWeightsManager.semiBold,
      color: AppColors.deepEmerald,
    ),
    titleLarge: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s18,
      fontWeight: FontWeightsManager.medium,
      color: AppColors.deepEmerald,
    ),
    titleMedium: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s16,
      fontWeight: FontWeightsManager.medium,
      color: AppColors.deepEmerald,
    ),
    titleSmall: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s14,
      fontWeight: FontWeightsManager.medium,
      color: AppColors.mutedEmerald,
    ),
    bodyLarge: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s16,
      fontWeight: FontWeightsManager.regular,
      color: AppColors.deepEmerald,
    ),
    bodyMedium: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s14,
      fontWeight: FontWeightsManager.regular,
      color: AppColors.deepEmerald,
    ),
    bodySmall: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s12,
      fontWeight: FontWeightsManager.regular,
      color: AppColors.mutedEmerald,
    ),
    labelLarge: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s14,
      fontWeight: FontWeightsManager.medium,
      color: AppColors.emerald,
    ),
    labelMedium: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s12,
      fontWeight: FontWeightsManager.medium,
      color: AppColors.emerald,
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

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  fontFamily: kUiFontFamily,
  scaffoldBackgroundColor: AppColors.darkBackground,
  primaryColor: AppColors.limeGold,
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.limeGold,
    onPrimary: AppColors.deepEmerald,
    secondary: AppColors.islamicTeal,
    onSecondary: AppColors.white,
    error: AppColors.softDanger,
    onError: AppColors.white,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkText,
    surfaceContainerHighest: AppColors.darkSurfaceMuted,
    onSurfaceVariant: AppColors.darkTextMuted,
    outlineVariant: AppColors.mutedEmerald,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    iconTheme: const IconThemeData(color: AppColors.darkText),
    titleTextStyle: TextStyle(
      fontFamily: kUiFontFamily,
      fontSize: FontSize.s18,
      fontWeight: FontWeightsManager.semiBold,
      color: AppColors.darkText,
    ),
  ),
  cardTheme: CardThemeData(
    color: AppColors.darkSurface,
    elevation: 0,
    shadowColor: AppColors.black.withAlpha(60),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSize.s18.r),
      side: BorderSide(color: AppColors.mutedEmerald.withAlpha(90)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.darkSurface,
    contentPadding: EdgeInsets.all(AppPadding.p16.w),
    hintStyle: TextStyle(
      fontFamily: kUiFontFamily,
      color: AppColors.darkTextMuted,
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
      color: AppColors.darkText,
    ),
    displayMedium: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s28,
      fontWeight: FontWeightsManager.bold,
      color: AppColors.darkText,
    ),
    displaySmall: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s24,
      fontWeight: FontWeightsManager.bold,
      color: AppColors.darkText,
    ),
    headlineLarge: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s22,
      fontWeight: FontWeightsManager.semiBold,
      color: AppColors.darkText,
    ),
    headlineMedium: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s20,
      fontWeight: FontWeightsManager.semiBold,
      color: AppColors.darkText,
    ),
    headlineSmall: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s18,
      fontWeight: FontWeightsManager.semiBold,
      color: AppColors.darkText,
    ),
    titleLarge: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s18,
      fontWeight: FontWeightsManager.medium,
      color: AppColors.darkText,
    ),
    titleMedium: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s16,
      fontWeight: FontWeightsManager.medium,
      color: AppColors.darkText,
    ),
    titleSmall: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s14,
      fontWeight: FontWeightsManager.medium,
      color: AppColors.darkTextMuted,
    ),
    bodyLarge: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s16,
      fontWeight: FontWeightsManager.regular,
      color: AppColors.darkText,
    ),
    bodyMedium: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s14,
      fontWeight: FontWeightsManager.regular,
      color: AppColors.darkText,
    ),
    bodySmall: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s12,
      fontWeight: FontWeightsManager.regular,
      color: AppColors.darkTextMuted,
    ),
    labelLarge: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s14,
      fontWeight: FontWeightsManager.medium,
      color: AppColors.limeGold,
    ),
    labelMedium: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s12,
      fontWeight: FontWeightsManager.medium,
      color: AppColors.limeGold,
    ),
    labelSmall: TextStyle(
      fontFamily: kUiFontFamily,
      fontFamilyFallback: const [kArabicFontFamilyPlaceholder],
      fontSize: FontSize.s10,
      fontWeight: FontWeightsManager.regular,
      color: AppColors.darkTextMuted,
    ),
  ),
);

ThemeData getApplicationLDarkTheme() => darkTheme;
