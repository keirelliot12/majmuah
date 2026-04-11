import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../../app/resources/color_manager.dart';
import '../../../../app/resources/values.dart';

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
        backgroundColor: Colors.white.withAlpha(180),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
          side: const BorderSide(color: Colors.white, width: 1.5),
        ),
        contentPadding: EdgeInsets.all(AppPadding.p24.r),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: ColorManager.gold.withAlpha(50),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Symbols.download_for_offline,
                size: 48.sp,
                color: ColorManager.gold,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "Download Diperlukan",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: ColorManager.lightPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(20),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Symbols.database, size: 18.sp, color: Colors.black54),
                  SizedBox(width: 8.w),
                  Text(
                    "Ukuran: ~$totalSize",
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
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
                      "Nanti",
                      style: TextStyle(color: Colors.grey[600]),
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
                      backgroundColor: ColorManager.lightPrimary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: const Text("Download"),
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
