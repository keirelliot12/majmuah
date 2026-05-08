import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/resources/resources.dart';

class ReadingParagraphCard extends StatelessWidget {
  final String text;
  final Color categoryColor;
  final double fontScale;

  static final RegExp _arabicTextPattern = RegExp(
    r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]',
  );

  const ReadingParagraphCard({
    Key? key,
    required this.text,
    required this.categoryColor,
    required this.fontScale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasArabicText = _arabicTextPattern.hasMatch(text);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p20.w,
        vertical: AppPadding.p24.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: categoryColor.withAlpha(31)),
        boxShadow: [
          BoxShadow(
            color: categoryColor.withAlpha(18),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Text(
        text,
        textAlign: hasArabicText ? TextAlign.right : TextAlign.start,
        textDirection: hasArabicText ? TextDirection.rtl : null,
        style: hasArabicText
            ? TextStyle(
                fontFamily: 'UthmanTN',
                fontSize: 20.sp * fontScale,
                height: 2,
                color: AppColors.darkerTeal,
              )
            : textTheme.bodyLarge?.copyWith(
                  fontSize: 16.sp,
                  height: 1.7,
                  color: AppColors.darkerTeal,
                ) ??
                TextStyle(
                  fontSize: 16.sp,
                  height: 1.7,
                  color: AppColors.darkerTeal,
                ),
      ),
    );
  }
}
