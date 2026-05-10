import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/resources/resources.dart';

class ReadingParagraphCard extends StatelessWidget {
  final String text;
  final Color categoryColor;
  final double fontScale;
  final String arabicFontFamily;
  final bool nightMode;
  final TextAlign? textAlign;

  static final RegExp _arabicTextPattern = RegExp(
    r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]',
  );

  const ReadingParagraphCard({
    Key? key,
    required this.text,
    required this.categoryColor,
    required this.fontScale,
    this.arabicFontFamily = FontConstants.uthmanTNFontFamily,
    this.nightMode = false,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasArabicText = _arabicTextPattern.hasMatch(text);
    final textTheme = Theme.of(context).textTheme;

    if (text.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Directionality(
      textDirection: hasArabicText ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        width: double.infinity,
        padding: EdgeInsetsDirectional.only(
          start: hasArabicText ? 0 : 14.w,
          end: hasArabicText ? 0 : 2.w,
          top: 2.h,
          bottom: 2.h,
        ),
        decoration: hasArabicText
            ? null
            : BoxDecoration(
                border: BorderDirectional(
                  start: BorderSide(
                    color: categoryColor.withAlpha(56),
                    width: 2.w,
                  ),
                ),
              ),
        child: Text(
          text.trim(),
          textAlign: textAlign ?? TextAlign.justify,
          style: hasArabicText
              ? TextStyle(
                  fontFamily: arabicFontFamily,
                  fontSize: 21.sp * fontScale,
                  height: 2.05,
                  color: nightMode ? AppColors.surface : AppColors.deepEmerald,
                )
              : textTheme.bodyLarge?.copyWith(
                      fontSize: 16.sp,
                      height: 1.78,
                      color: nightMode
                          ? AppColors.surface.withAlpha(230)
                          : AppColors.deepEmerald.withAlpha(232),
                    ) ??
                    TextStyle(
                      fontSize: 16.sp,
                      height: 1.78,
                      color: nightMode
                          ? AppColors.surface.withAlpha(230)
                          : AppColors.deepEmerald.withAlpha(232),
                    ),
        ),
      ),
    );
  }
}
