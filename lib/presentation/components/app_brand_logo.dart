import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/resources/resources.dart';

class AppBrandLogo extends StatelessWidget {
  final double size;
  final bool showLabel;

  const AppBrandLogo({super.key, this.size = 56, this.showLabel = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size.w,
          height: size.w,
          padding: EdgeInsets.all(5.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: AppColors.limeGold.withAlpha(120)),
            boxShadow: [
              BoxShadow(
                color: AppColors.deepEmerald.withAlpha(20),
                blurRadius: 16.r,
                offset: Offset(0, 8.h),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13.r),
            child: Image.asset(ImageAsset.anNibrosLogo, fit: BoxFit.cover),
          ),
        ),
        if (showLabel) ...[
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'AN NIBROS',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.deepEmerald,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                ),
              ),
              Text(
                'Amaliyah & Aurad Salafus Sholeh',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.mutedEmerald,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
