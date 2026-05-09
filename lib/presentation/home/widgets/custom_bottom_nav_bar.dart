import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../../app/resources/resources.dart';

/// Custom Bottom Navigation Bar with 5 items for the home screen.
///
/// Items from left to right:
/// 1. Beranda
/// 2. Al-Quran
/// 3. Shalat
/// 4. Dzikir
/// 5. Setelan
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 10.h),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.p10.w,
            vertical: AppPadding.p8.h,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(28.r),
            border: Border.all(
              color: AppColors.darkTeal.withAlpha(18),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkerTeal.withAlpha(22),
                blurRadius: 24.r,
                offset: Offset(0, 10.r),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                icon: Symbols.home,
                label: 'Beranda',
                index: 0,
                isActive: currentIndex == 0,
                onTap: () => onTabChanged(0),
              ),
              _buildNavItem(
                context,
                icon: Symbols.local_library,
                label: 'Al-Quran',
                index: 1,
                isActive: currentIndex == 1,
                onTap: () => onTabChanged(1),
              ),
              _buildNavItem(
                context,
                icon: Symbols.schedule,
                label: 'Shalat',
                index: 2,
                isActive: currentIndex == 2,
                onTap: () => onTabChanged(2),
              ),
              _buildNavItem(
                context,
                icon: Symbols.star_half,
                label: 'Dzikir',
                index: 3,
                isActive: currentIndex == 3,
                onTap: () => onTabChanged(3),
              ),
              _buildNavItem(
                context,
                icon: Symbols.settings,
                label: 'Setelan',
                index: 4,
                isActive: currentIndex == 4,
                onTap: () => onTabChanged(4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final color = isActive ? AppColors.deepEmerald : AppColors.mutedEmerald;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 56.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.limeGold.withAlpha(76)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                icon,
                size: 22.r,
                color: color,
                fill: isActive ? 1 : 0,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: isActive
                    ? FontWeightsManager.bold
                    : FontWeightsManager.medium,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
