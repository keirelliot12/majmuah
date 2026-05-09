import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/resources/resources.dart';
import '../helpers/category_visuals.dart';

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

/// Displays a compact 4x2 grid of menu items for the home screen.
class MenuGridWidget extends StatelessWidget {
  final List<MenuItemModel> menuItems;

  const MenuGridWidget({Key? key, required this.menuItems}) : super(key: key);

  /// Creates default menu items matching the reference design
  static List<MenuItemModel> createDefaultMenuItems({
    required VoidCallback onAuradDoaTap,
    required VoidCallback onHizibRatibTap,
    required VoidCallback onPujiBilalTap,
    required VoidCallback onAmalanHijriyahTap,
    required VoidCallback onMaulidTap,
    required VoidCallback onTahlilZiarahTap,
    required VoidCallback onKbihuTap,
    required VoidCallback onLainnyaTap,
  }) {
    return [
      // Row 1
      _createMenuItem(title: "Aurad & Doa'", onTap: onAuradDoaTap),
      _createMenuItem(title: 'Hizib & Ratib', onTap: onHizibRatibTap),
      _createMenuItem(title: 'Puji & Bilal', onTap: onPujiBilalTap),
      _createMenuItem(title: 'Amalan Hijriyah', onTap: onAmalanHijriyahTap),
      // Row 2
      _createMenuItem(title: 'Maulid', onTap: onMaulidTap),
      _createMenuItem(title: 'Tahlil & Ziarah', onTap: onTahlilZiarahTap),
      _createMenuItem(title: 'KBIHU', onTap: onKbihuTap),
      _createMenuItem(title: 'Lainnya', onTap: onLainnyaTap),
    ];
  }

  static MenuItemModel _createMenuItem({
    required String title,
    required VoidCallback onTap,
  }) {
    final visual = CategoryVisuals.forCategory(title);

    return MenuItemModel(
      title: title,
      icon: visual.icon,
      iconColor: visual.color,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 10.w,
          crossAxisSpacing: 10.w,
          childAspectRatio: 0.72,
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
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white.withAlpha(246),
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(
                      color: AppColors.darkTeal.withAlpha(14),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.darkerTeal.withAlpha(12),
                        blurRadius: 12.r,
                        offset: Offset(0, 5.r),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: item.iconColor.withAlpha(24),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(item.icon, size: 22.r, color: item.iconColor),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            item.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeightsManager.bold,
              color: AppColors.darkerTeal,
            ),
          ),
        ],
      ),
    );
  }
}
