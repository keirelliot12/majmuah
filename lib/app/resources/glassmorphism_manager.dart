import 'package:flutter/material.dart';
import 'values.dart';

class GlassmorphismConfig {
  static const double defaultBlur = 10.0;
  static const double defaultOpacity = 0.3;
  static const double defaultRadius = AppSize.s20;

  static final BoxDecoration decoration = BoxDecoration(
    color: Colors.white.withOpacity(defaultOpacity),
    borderRadius: BorderRadius.circular(defaultRadius),
    border: Border.all(
      color: Colors.white.withOpacity(defaultOpacity),
      width: 1.0,
    ),
  );

  static const LinearGradient homeBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFE8F682), // lemonYellow
      Color(0xFF2F9E84), // islamicTeal
    ],
  );
}
