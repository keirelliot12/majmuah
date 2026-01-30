import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../../app/resources/resources.dart';

/// Displays a card showing the last read content.
///
/// Features:
/// - Book icon with blue background on left
/// - "Terakhir Dibaca" label with content title
/// - Chevron right on the right side
/// - iOS-style shadow
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
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: AppPadding.p24.w,
          vertical: AppPadding.p8.h,
        ),
        padding: EdgeInsets.all(AppPadding.p16.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20.r,
              offset: Offset(0, 4.r),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left: Book icon with blue background
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF), // blue-50
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Symbols.menu_book,
                color: AppColors.blue500,
                size: 24.r,
              ),
            ),
            SizedBox(width: AppSize.s12.w),

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
                      color: AppColors.gray,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: AppSize.s4.h),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeightsManager.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),

            // Right: Chevron
            Icon(
              Symbols.chevron_right,
              color: Colors.grey.shade300,
              size: 24.r,
            ),
          ],
        ),
      ),
    );
  }
}
