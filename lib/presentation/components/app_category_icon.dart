import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppCategoryIcon extends StatelessWidget {
  final String? assetPath;
  final IconData fallbackIcon;
  final Color color;
  final double size;

  const AppCategoryIcon({
    super.key,
    required this.assetPath,
    required this.fallbackIcon,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final path = assetPath;
    if (path != null && path.trim().isNotEmpty) {
      return Image.asset(
        path,
        width: size.r,
        height: size.r,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }

    return _fallback();
  }

  Widget _fallback() {
    return Icon(fallbackIcon, size: size.r, color: color);
  }
}
