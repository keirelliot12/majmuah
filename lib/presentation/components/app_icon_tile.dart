import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/resources/resources.dart';

class AppIconTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const AppIconTile({
    super.key,
    required this.icon,
    this.color = AppColors.deepEmerald,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        color: color.withAlpha(22),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withAlpha(52)),
      ),
      child: Icon(icon, color: color, size: (size * 0.48).r),
    );
  }
}
