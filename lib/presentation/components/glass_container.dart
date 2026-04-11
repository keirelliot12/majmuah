import 'dart:ui';
import 'package:flutter/material.dart';
import '../../app/resources/values.dart';

class GlassContainer extends StatelessWidget {
  final Widget? child;
  final double blur;
  final double opacity;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color shadowColor;
  final double elevation;
  final double borderWidth;
  final Color? borderColor;
  final double? width;
  final double? height;

  const GlassContainer({
    Key? key,
    this.child,
    this.blur = 10.0,
    this.opacity = 0.3,
    this.borderRadius = AppSize.s20,
    this.padding,
    this.shadowColor = Colors.black12,
    this.elevation = 0.0,
    this.borderWidth = 1.0,
    this.borderColor,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: elevation,
                  spreadRadius: 0,
                  offset: Offset(0, elevation / 2),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha((opacity * 255).toInt()),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColor ?? Colors.white.withAlpha((0.3 * 255).toInt()),
                width: borderWidth,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
