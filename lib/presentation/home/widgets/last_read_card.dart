import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:annibros/app/resources/resources.dart';

/// Displays a card showing the last read content with glassmorphism.
///
/// Features:
/// - Glassmorphism background (white/40 with blur)
/// - Book icon with blue background on left
/// - "Terakhir Dibaca" label with content title
/// - Chevron right on the right side
class LastReadCard extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const LastReadCard({Key? key, this.title = 'Ratib Al-Haddad', this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 22.0.w, vertical: 7.0.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: EdgeInsets.all(16.0.w),
              decoration: BoxDecoration(
                color: AppColors.white.withAlpha(244),
                borderRadius: BorderRadius.circular(22.r),
                border: Border.all(
                  color: AppColors.darkTeal.withAlpha(16),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.darkerTeal.withAlpha(14),
                    blurRadius: 14.r,
                    offset: Offset(0, 6.r),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: AppColors.lemonYellow.withAlpha(92),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Icon(
                      Symbols.menu_book,
                      color: AppColors.darkTeal,
                      size: 24.r,
                    ),
                  ),
                  SizedBox(width: AppSize.s16.w),

                  // Center: Label and title
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TERAKHIR DIBACA',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeightsManager.bold,
                            color: AppColors.darkTeal.withAlpha(166),
                            letterSpacing: 0,
                          ),
                        ),
                        SizedBox(height: AppSize.s4.h),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeightsManager.bold,
                            color: AppColors.darkerTeal,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right: Chevron
                  Icon(
                    Symbols.chevron_right,
                    color: ColorManager.gold.withAlpha(178),
                    size: 24.r,
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
