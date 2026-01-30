import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../../app/resources/resources.dart';

/// Custom Bottom Navigation Bar with 5 items for the home screen.
///
/// Items (matching reference design from left to right):
/// 1. Al-Quran (book icon)
/// 2. Adzkar (star half icon)
/// 3. Beranda (home icon) - Center/Active with background highlight
/// 4. Waktu Shalat (clock icon)
/// 5. Pengaturan (settings icon)
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.r),
          topRight: Radius.circular(40.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15.r,
            offset: Offset(0, -4.r),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.p16.w,
            vertical: AppPadding.p12.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 1. Al-Quran
              _buildNavItem(
                context,
                icon: Symbols.local_library,
                label: 'Al-Quran',
                index: 1,
                isActive: currentIndex == 1,
                onTap: () => onTabChanged(1),
              ),
              // 2. Adzkar
              _buildNavItem(
                context,
                icon: Symbols.star_half,
                label: 'Adzkar',
                index: 3,
                isActive: currentIndex == 3,
                onTap: () => onTabChanged(3),
              ),
              // 3. Beranda (Home) - Center with special styling
              _buildCenterNavItem(
                context,
                icon: Symbols.home,
                label: 'Beranda',
                index: 0,
                isActive: currentIndex == 0,
                onTap: () => onTabChanged(0),
              ),
              // 4. Waktu Shalat
              _buildNavItem(
                context,
                icon: Symbols.schedule,
                label: 'Waktu Shalat',
                index: 2,
                isActive: currentIndex == 2,
                onTap: () => onTabChanged(2),
              ),
              // 5. Pengaturan
              _buildNavItem(
                context,
                icon: Symbols.settings,
                label: 'Pengaturan',
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
    final color = isActive ? AppColors.islamicTeal : AppColors.gray;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24.r,
            color: color,
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeightsManager.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Highlight container for active home
          Container(
            padding: EdgeInsets.all(10.w),
            margin: EdgeInsets.only(bottom: 4.h),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.islamicTeal.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              icon,
              size: 24.r,
              color: isActive ? AppColors.islamicTeal : AppColors.gray,
              fill: isActive ? 1 : 0,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeightsManager.bold,
              color: isActive ? AppColors.islamicTeal : AppColors.gray,
            ),
          ),
        ],
      ),
    );
  }
}
