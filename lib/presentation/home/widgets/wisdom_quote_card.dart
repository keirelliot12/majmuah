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
    this.quote = '"Sesungguhnya bersama kesulitan ada kemudahan. Maka apabila engkau telah selesai (dari sesuatu urusan), tetaplah bekerja keras (untuk urusan yang lain)."',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 24.0.w,
        vertical: 8.0.h,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.all(20.0.w),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: Colors.white.withAlpha(51), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Quote icon + label
                Row(
                  children: [
                    Icon(
                      Symbols.format_quote,
                      color: Colors.white,
                      size: 16.r,
                    ),
                    SizedBox(width: 8.0.w),
                    Text(
                      'MUTIARA HIKMAH',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeightsManager.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
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
                    color: Colors.white,
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
