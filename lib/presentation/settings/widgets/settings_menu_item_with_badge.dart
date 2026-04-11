import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/resources/color_manager.dart';
import '../../../app/resources/values.dart';
import '../../download/cubit/download_cubit.dart';
import '../../download/cubit/download_state.dart';

/// Settings Menu Item dengan Sync Badge
///
/// Menampilkan menu item settings dengan indikator update jika ada konten baru
class SettingsMenuItemWithBadge extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onTap;
  final bool showSyncBadge;

  const SettingsMenuItemWithBadge({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconColor,
    required this.onTap,
    this.showSyncBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    if (showSyncBadge) {
      return BlocBuilder<DownloadCubit, DownloadState>(
        builder: (context, state) {
          bool hasUpdate = false;
          if (state is DownloadManifestLoaded) {
            hasUpdate = state.isUpdateAvailable;
          }

          return _buildMenuItem(context, hasUpdate);
        },
      );
    }

    return _buildMenuItem(context, false);
  }

  Widget _buildMenuItem(BuildContext context, bool hasUpdate) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.p16.r,
            vertical: AppPadding.p12.r,
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  Icon(
                    icon,
                    color: iconColor ?? ColorManager.gold,
                    size: 24.sp,
                  ),
                  if (hasUpdate && showSyncBadge)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withValues(alpha: 0.5),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      hasUpdate && showSyncBadge
                          ? "✦ Pembaruan tersedia"
                          : subtitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: hasUpdate && showSyncBadge
                            ? Colors.red
                            : Colors.grey[600],
                        fontWeight: hasUpdate && showSyncBadge
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasUpdate && showSyncBadge)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(color: Colors.red, width: 0.5),
                  ),
                  child: Text(
                    "Baru",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                  size: 20.sp,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
