import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:islamic/app/resources/resources.dart';

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

  const LastReadCard({
    Key? key,
    this.title = 'Ratib Al-Haddad',
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 24.0.w,
          vertical: 8.0.h,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.all(16.0.w),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(102), // ~40% white
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: Colors.white.withAlpha(51), width: 1),
              ),
              child: Row(
                children: [
                  // Left: Book icon with blue background
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: AppColors.blue500.withAlpha(26), // blue with low alpha
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Icon(
                      Symbols.menu_book,
                      color: AppColors.blue500,
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
                            color: Colors.grey.shade700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: AppSize.s4.h),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeightsManager.bold,
                            color: Colors.grey.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right: Chevron
                  Icon(
                    Symbols.chevron_right,
                    color: Colors.grey.shade400,
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
