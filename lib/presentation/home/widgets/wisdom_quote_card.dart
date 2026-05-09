import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:islamic/app/resources/resources.dart';

/// Displays a wisdom quote card with glassmorphism effect.
///
/// Features:
/// - Glassmorphism background (white/20 with blur)
/// - Quote icon and "MUTIARA HIKMAH" label
/// - Italic quote text
class WisdomQuoteCard extends StatelessWidget {
  final String quote;

  const WisdomQuoteCard({
    Key? key,
    this.quote =
        '"Sesungguhnya bersama kesulitan ada kemudahan. Maka apabila engkau telah selesai (dari sesuatu urusan), tetaplah bekerja keras (untuk urusan yang lain)."',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.0.w, vertical: 8.0.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: EdgeInsets.all(20.0.w),
            decoration: BoxDecoration(
              color: AppColors.darkTeal,
              borderRadius: BorderRadius.circular(22.r),
              border: Border.all(
                color: AppColors.lemonYellow.withAlpha(46),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkerTeal.withAlpha(24),
                  blurRadius: 16.r,
                  offset: Offset(0, 8.r),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Quote icon + label
                Row(
                  children: [
                    Icon(
                      Symbols.format_quote,
                      color: AppColors.lemonYellow,
                      size: 16.r,
                    ),
                    SizedBox(width: 8.0.w),
                    Text(
                      'MUTIARA HIKMAH',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeightsManager.bold,
                        color: AppColors.white.withAlpha(222),
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.0.h),

                // Quote text
                Text(
                  quote,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeightsManager.medium,
                    fontStyle: FontStyle.italic,
                    color: AppColors.white.withAlpha(230),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
