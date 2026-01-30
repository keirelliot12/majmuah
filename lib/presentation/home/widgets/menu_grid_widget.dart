import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../../app/resources/resources.dart';

/// Model for menu items
class MenuItemModel {
  final String title;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  MenuItemModel({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });
}

/// Displays a 4x2 grid of menu items for the home screen.
///
/// Features:
/// - 8 menu items in a 4-column grid (2 rows)
/// - White card styling with iOS shadow
/// - Material Symbols icons
/// - White text labels with drop shadow for visibility
class MenuGridWidget extends StatelessWidget {
  final List<MenuItemModel> menuItems;

  const MenuGridWidget({
    Key? key,
    required this.menuItems,
  }) : super(key: key);

  /// Creates default menu items matching the reference design
  static List<MenuItemModel> createDefaultMenuItems({
    required VoidCallback onAuradSholatTap,
    required VoidCallback onDoaTawasulTap,
    required VoidCallback onRatibTap,
    required VoidCallback onKhutbahTap,
    required VoidCallback onMaulidTap,
    required VoidCallback onTahlilZiarahTap,
    required VoidCallback onNotesTap,
    required VoidCallback onLainnyaTap,
  }) {
    return [
      // Row 1
      MenuItemModel(
        title: 'Aurad Sholat',
        icon: Symbols.mosque,
        iconColor: AppColors.emerald500,
        onTap: onAuradSholatTap,
      ),
      MenuItemModel(
        title: 'Doa & Tawassul',
        icon: Symbols.front_hand,
        iconColor: AppColors.amber500,
        onTap: onDoaTawasulTap,
      ),
      MenuItemModel(
        title: 'Ratib',
        icon: Symbols.auto_stories,
        iconColor: AppColors.indigo500,
        onTap: onRatibTap,
      ),
      MenuItemModel(
        title: 'Khutbah',
        icon: Symbols.record_voice_over,
        iconColor: AppColors.rose500,
        onTap: onKhutbahTap,
      ),
      // Row 2
      MenuItemModel(
        title: 'Maulid',
        icon: Symbols.auto_awesome,
        iconColor: AppColors.orange500,
        onTap: onMaulidTap,
      ),
      MenuItemModel(
        title: 'Tahlil & Ziarah',
        icon: Symbols.history_edu,
        iconColor: AppColors.teal600,
        onTap: onTahlilZiarahTap,
      ),
      MenuItemModel(
        title: 'Notes',
        icon: Symbols.edit_note,
        iconColor: AppColors.cyan600,
        onTap: onNotesTap,
      ),
      MenuItemModel(
        title: 'Lainnya',
        icon: Symbols.grid_view,
        iconColor: AppColors.gray500,
        onTap: onLainnyaTap,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.p24.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 12.w,
          crossAxisSpacing: 12.w,
          childAspectRatio: 0.75,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return _buildMenuCard(context, item);
        },
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, MenuItemModel item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon card with glassmorphism
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(102), // ~40% white
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.white.withAlpha(51), width: 1),
                  ),
                  child: Center(
                    child: Icon(
                      item.icon,
                      size: 28.r,
                      color: item.iconColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          // Label with drop shadow for visibility
          Text(
            item.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeightsManager.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
