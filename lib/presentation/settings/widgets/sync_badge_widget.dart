import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../app/resources/values.dart';
import '../../download/cubit/download_cubit.dart';
import '../../download/cubit/download_state.dart';
import 'dart:developer' as developer;

/// Sync Badge Widget - Menampilkan notifikasi jika konten baru tersedia
///
/// Digunakan di Settings Screen dan Download Manager untuk memberitahu
/// user bahwa ada update konten di server
class SyncBadgeWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final bool compact;

  const SyncBadgeWidget({
    super.key,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DownloadCubit, DownloadState>(
      builder: (context, state) {
        developer.log('🎨 SyncBadgeWidget building with state: ${state.runtimeType}');

        // Hanya tampilkan badge jika ada update tersedia
        if (state is! DownloadManifestLoaded) {
          developer.log('  → State is not DownloadManifestLoaded');
          return const SizedBox.shrink();
        }

        final isUpdate = state.isUpdateAvailable;
        developer.log('  → isUpdateAvailable: $isUpdate');

        if (!isUpdate) {
          developer.log('  → No update available, hiding badge');
          return const SizedBox.shrink();
        }

        developer.log('  → ✅ Showing badge (mode: ${compact ? 'compact' : 'expanded'})');

        if (compact) {
          return _buildCompactBadge();
        } else {
          return _buildExpandedBadge(context);
        }
      },
    );
  }

  /// Compact badge untuk Settings menu item (hanya dot/badge kecil)
  Widget _buildCompactBadge() {
    return Container(
      width: 12.w,
      height: 12.w,
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.5),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  /// Expanded badge untuk info detail
  Widget _buildExpandedBadge(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.red.shade400,
            Colors.red.shade600,
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.3),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.p16.r,
              vertical: AppPadding.p12.r,
            ),
            child: Row(
              children: [
                Icon(
                  Symbols.update,
                  color: Colors.white,
                  size: 22.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Pembaruan Tersedia",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "Konten baru menunggu untuk disinkronkan",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Icon(
                  Symbols.arrow_forward,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
