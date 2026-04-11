import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../../app/resources/color_manager.dart';
import '../../../../app/resources/values.dart';
import '../../../domain/models/download/download_status.dart';

class DownloadProgressSheet extends StatelessWidget {
  final DownloadProgress progress;
  final int currentChunk;
  final int totalChunks;

  const DownloadProgressSheet({
    super.key,
    required this.progress,
    required this.currentChunk,
    required this.totalChunks,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent sheet from closing during download
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(AppPadding.p24.r),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(200),
            borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
            border: Border.all(color: Colors.white.withAlpha(100), width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: ColorManager.lightPrimary.withAlpha(30),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Symbols.downloading,
                      color: ColorManager.lightPrimary,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mengunduh Al-Quran",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Bagian $currentChunk dari $totalChunks",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "${progress.percentage.toInt()}%",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.lightPrimary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: LinearProgressIndicator(
                  value: progress.percentage / 100,
                  backgroundColor: ColorManager.lightPrimary.withAlpha(30),
                  valueColor: AlwaysStoppedAnimation<Color>(ColorManager.lightPrimary),
                  minHeight: 12.h,
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatBytes(progress.bytesReceived),
                    style: TextStyle(fontSize: 12.sp, color: Colors.black54),
                  ),
                  Text(
                    _formatBytes(progress.totalBytes),
                    style: TextStyle(fontSize: 12.sp, color: Colors.black54),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Text(
                "Mohon jangan tutup aplikasi",
                style: TextStyle(
                  fontSize: 11.sp,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[500],
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (bytes.bitLength - 1) ~/ 10;
    return "${(bytes / (1 << (i * 10))).toStringAsFixed(1)} ${suffixes[i]}";
  }
}
