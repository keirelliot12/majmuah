import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color_manager.dart';
import 'font_manager.dart';

TextStyle _getTextStyle({
  required double fontSize,
  String fontFamily = FontConstants.poppinsFontFamily, // Use Poppins for modern UI
  required FontWeight fontWeight,
  required Color color,
}) {
  // Use Google Fonts for Poppins, fallback to local fonts for Arabic
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
