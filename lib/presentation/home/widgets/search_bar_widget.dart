import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:annibros/app/resources/resources.dart';

/// A customized search bar widget for the home screen with glassmorphism.
///
/// Features:
/// - Glassmorphism background (white/40 with blur)
/// - Search icon on the left (Material Symbols)
/// - Placeholder text
class SearchBarWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final String hintText;

  const SearchBarWidget({
    Key? key,
    this.onTap,
    this.hintText = 'Cari Surah, Wirid, atau Doa...',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 22.0.w, vertical: 7.0.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0.w,
                vertical: 13.0.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.white.withAlpha(242),
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(
                  color: AppColors.darkTeal.withAlpha(16),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.darkerTeal.withAlpha(16),
                    blurRadius: 14.r,
                    offset: Offset(0, 6.r),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Symbols.search,
                    color: AppColors.darkTeal.withAlpha(178),
                    size: 22.0.r,
                  ),
                  SizedBox(width: 12.0.w),
                  Expanded(
                    child: Text(
                      hintText,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.darkerTeal.withAlpha(166),
                        fontSize: FontSize.s14,
                        fontWeight: FontWeightsManager.medium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
