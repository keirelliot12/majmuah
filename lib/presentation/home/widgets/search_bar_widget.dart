import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../../app/resources/resources.dart';

/// A customized search bar widget for the home screen.
///
/// Features:
/// - White background with rounded corners
/// - Search icon on the left (Material Symbols)
/// - Placeholder text
/// - iOS-style shadow
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
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: AppPadding.p24.w,
          vertical: AppPadding.p8.h,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.p16.w,
          vertical: AppPadding.p14.h,
        ),
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
            Icon(
              Symbols.search,
              color: AppColors.gray,
              size: AppSize.s22.r,
            ),
            SizedBox(width: AppPadding.p12.w),
            Expanded(
              child: Text(
                hintText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.gray,
                      fontSize: FontSize.s14,
                      fontWeight: FontWeightsManager.medium,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
