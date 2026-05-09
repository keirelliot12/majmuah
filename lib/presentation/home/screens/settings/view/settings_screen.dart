import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/resources/resources.dart';

import '../../../cubit/home_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        bool darkMode = cubit.darkModeOn(context);
        final colorScheme = Theme.of(context).colorScheme;
        return ListView(
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.p16.w,
            vertical: AppPadding.p12.h,
          ),
          children: [
            _sectionLabel('Pengaturan Aplikasi'),
            _settingIndexItem(
              icon: Icons.download_for_offline_outlined,
              settingName: "Kelola Unduhan",
              trailing: Icon(
                Icons.chevron_right,
                color: AppColors.darkerTeal.withAlpha(130),
              ),
              onTap: () {
                Navigator.pushNamed(context, Routes.downloadManagerRoute);
              },
              context: context,
            ),
            _settingIndexItem(
              icon: Icons.brightness_2_outlined,
              settingName: AppStrings.changeAppTheme.tr(),
              trailing: Switch(
                overlayColor: WidgetStateColor.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.tealGreen.withAlpha(30);
                  } else {
                    return AppColors.lemonYellow.withAlpha(45);
                  }
                }),
                activeTrackColor: AppColors.tealGreen.withAlpha(95),
                thumbIcon: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return const Icon(
                      Icons.brightness_2_outlined,
                      color: AppColors.white,
                    );
                  } else {
                    return const Icon(
                      Icons.brightness_5,
                      color: AppColors.darkerTeal,
                    );
                  }
                }),
                inactiveTrackColor: AppColors.lemonYellow.withAlpha(90),
                thumbColor: WidgetStateColor.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.tealGreen;
                  } else {
                    return AppColors.lemonYellow;
                  }
                }),
                value: darkMode,
                onChanged: (value) {
                  cubit.changeAppTheme(context);
                },
              ),
              onTap: () {
                cubit.changeAppTheme(context);
              },
              context: context,
            ),
            SizedBox(height: AppSize.s30.h),
            Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppSize.s24.r),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withAlpha(120),
                  ),
                  boxShadow: AppColors.softShadow,
                ),
                child: Padding(
                  padding: EdgeInsets.all(AppPadding.p12.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSize.s18.r),
                    child: Image.asset(
                      ImageAsset.anNibrosLogo,
                      width: AppSize.s140.w,
                      height: AppSize.s140.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _settingIndexItem({
    required IconData? icon,
    required String settingName,
    required Widget? trailing,
    required Function onTap,
    required BuildContext context,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: AppPadding.p10.h),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppSize.s16.r),
          border: Border.all(color: colorScheme.outlineVariant.withAlpha(120)),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppPadding.p16.w,
            vertical: AppPadding.p8.h,
          ),
          leading: Container(
            width: 42.r,
            height: 42.r,
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(24),
              borderRadius: BorderRadius.circular(AppSize.s14.r),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 22.sp),
          ),
          title: Text(
            settingName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontFamily: FontConstants.elMessiriFontFamily,
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
              wordSpacing: AppSize.s3.w,
              letterSpacing: 0,
            ),
          ),
          trailing: trailing,
          onTap: () {
            onTap();
          },
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppPadding.p8.w,
        bottom: AppPadding.p8.h,
        top: AppPadding.p8.h,
      ),
      child: Builder(
        builder: (context) {
          return Text(
            label.toUpperCase(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          );
        },
      ),
    );
  }
}
