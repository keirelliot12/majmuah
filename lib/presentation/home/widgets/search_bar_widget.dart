import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:islamic/app/resources/resources.dart';

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
        padding: EdgeInsets.symmetric(
          horizontal: 24.0.w,
          vertical: 8.0.h,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50.r), // More rounded like reference
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 24.0.w,
                vertical: 14.0.h,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(102), // ~40% white
                borderRadius: BorderRadius.circular(50.r),
                border: Border.all(color: Colors.white.withAlpha(51), width: 1),
              ),
              child: Row(
                children: [
                  Icon(
                    Symbols.search,
                    color: Colors.grey.shade600,
                    size: 22.0.r,
                  ),
                  SizedBox(width: 12.0.w),
                  Expanded(
                    child: Text(
                      hintText,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
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
