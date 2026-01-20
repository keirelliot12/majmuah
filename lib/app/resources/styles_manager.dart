import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color_manager.dart';
import 'font_manager.dart';

/// Creates a TextStyle with the specified parameters.
/// 
/// **Font Strategy:**
/// - **Poppins (default)**: Used for modern UI elements via Google Fonts.
///   This provides a clean, readable font for non-Arabic content.
/// - **Arabic fonts (ElMessiri, UthmanTN, me_quran, Hafs)**: Used for 
///   Quranic content and Arabic text. These are loaded from local assets
///   to ensure proper rendering of Arabic script and Quranic typography.
///
/// When [fontFamily] is set to Poppins, Google Fonts is used.
/// For any other font family (Arabic fonts), local assets are used.
TextStyle _getTextStyle({
  required double fontSize,
  String fontFamily = FontConstants.poppinsFontFamily,
  required FontWeight fontWeight,
  required Color color,
}) {
  // Use Google Fonts for Poppins (modern UI)
  // Fallback to local font assets for Arabic/Quranic fonts
  if (fontFamily == FontConstants.poppinsFontFamily) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
  return TextStyle(
    fontSize: fontSize,
    fontFamily: fontFamily,
    fontWeight: fontWeight,
    color: color,
  );
}

//regular style
TextStyle getRegularStyle({
  required double fontSize,
  Color color = ColorManager.white,
}) {
  return _getTextStyle(
    fontSize: fontSize,
    fontWeight: FontWeightsManager.regular,
    color: color,
  );
}

//medium style
TextStyle getMediumStyle({
  required double fontSize,
  Color color = ColorManager.white,
}) {
  return _getTextStyle(
    fontSize: fontSize,
    fontWeight: FontWeightsManager.medium,
    color: color,
  );
}

//semi bold style
TextStyle getSemiBoldStyle({
  required double fontSize,
  Color color = ColorManager.white,
}) {
  return _getTextStyle(
    fontSize: fontSize,
    fontWeight: FontWeightsManager.semiBold,
    color: color,
  );
}

//bold style
TextStyle getBoldStyle({
  required double fontSize,
  Color color = ColorManager.white,
}) {
  return _getTextStyle(
    fontSize: fontSize,
    fontWeight: FontWeightsManager.bold,
    color: color,
  );
}
