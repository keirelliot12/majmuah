import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../../app/resources/resources.dart';

class DownloadPromptDialog extends StatelessWidget {
  final String featureName;
  final String description;
  final String totalSize;
  final VoidCallback onDownload;

  const DownloadPromptDialog({
    super.key,
    required this.featureName,
    required this.description,
    required this.totalSize,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22.r),
          side: BorderSide(color: AppColors.tealGreen.withAlpha(28), width: 1),
        ),
        contentPadding: EdgeInsets.all(AppPadding.p24.r),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColors.lemonYellow.withAlpha(55),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Symbols.download_for_offline,
                size: 48.sp,
                color: AppColors.tealGreen,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "Mushaf Belum Diunduh",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.darkerTeal,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.darkerTeal.withAlpha(190),
                height: 1.5,
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.offWhite,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.tealGreen.withAlpha(30)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Symbols.database,
                    size: 18.sp,
                    color: AppColors.tealGreen,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "Ukuran: ~$totalSize",
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkerTeal.withAlpha(170),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: Text(
                      "Download Nanti",
                      style: TextStyle(
                        color: AppColors.darkerTeal.withAlpha(155),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onDownload();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tealGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: const Text("Download Sekarang"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
