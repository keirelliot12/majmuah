import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../app/resources/resources.dart';
import 'app_brand_logo.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: AppSize.s200 * 1.2,
      child: Padding(
        padding: const EdgeInsets.only(top: AppPadding.p40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
              child: AppBrandLogo(size: 54, showLabel: true),
            ),
            const SizedBox(height: AppSize.s24),
            _draweritem(AppStrings.browse.tr(), () {
              Navigator.of(context).pushNamed(Routes.browsenetRoute);
            }),
          ],
        ),
      ),
    );
  }

  _draweritem(String title, void Function() ontap) {
    return InkWell(
      onTap: ontap,
      child: Container(
        margin: EdgeInsets.only(
          top: AppMargin.m16,
          left: AppMargin.m16,
          right: AppMargin.m16,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p16,
          vertical: AppPadding.p14,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSize.s16),
          border: Border.all(color: AppColors.softBorder),
        ),
        child: Row(
          children: [
            const Icon(Icons.play_circle_outline, color: AppColors.emerald),
            const SizedBox(width: AppSize.s12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: AppSize.s16,
                  color: AppColors.deepEmerald,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.mutedEmerald),
          ],
        ),
      ),
    );
  }
}
