import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../app/resources/resources.dart';
import '../download/cubit/download_cubit.dart';
import '../download/cubit/download_state.dart';
import '../download/widgets/download_prompt_dialog.dart';
import '../../di/di.dart';

class DownloadManagerScreen extends StatelessWidget {
  const DownloadManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<DownloadCubit>()..checkManifest(),
      child: Scaffold(
        backgroundColor: AppColors.offWhite,
        appBar: AppBar(
          title: const Text("Kelola Unduhan"),
          centerTitle: true,
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.darkerTeal,
          elevation: 0,
        ),
        body: BlocBuilder<DownloadCubit, DownloadState>(
          builder: (context, state) {
            return ListView(
              padding: EdgeInsets.all(AppPadding.p16.r),
              children: [
                _buildQuranDownloadCard(context, state),
                SizedBox(height: AppSize.s16.h),
                _buildSyncContentCard(),
                SizedBox(height: AppSize.s16.h),
                _buildCleanupCard(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildQuranDownloadCard(BuildContext context, DownloadState state) {
    bool isDownloaded = false;
    double progress = 0;
    String statusText = "Memuat...";
    Color? statusColor = Colors.grey[600];
    bool isLoading = state is DownloadInitial || state is DownloadManifestLoading;
    bool isDownloading = false;
    bool hasFailure = false;

    if (state is DownloadManifestLoaded) {
      isDownloaded = state.isQuranFullyDownloaded;
      final manifestChunkIds =
          state.manifest.quran.chunks.map((chunk) => chunk.id).toSet();
      final downloadedCount = state.downloadedChunks
          .where((chunkId) => manifestChunkIds.contains(chunkId))
          .length;
      final totalChunks = manifestChunkIds.length;
      progress = totalChunks == 0
          ? 0
          : (downloadedCount / totalChunks).clamp(0.0, 1.0).toDouble();
      statusText = isDownloaded
          ? "Semua halaman sudah terunduh"
          : "$downloadedCount dari $totalChunks bagian terunduh";
    } else if (state is DownloadProgressState) {
      isDownloading = true;
      final chunkProgress = (state.progress.percentage / 100).clamp(0.0, 1.0).toDouble();
      progress = state.totalChunks == 0
          ? 0
          : (((state.currentChunk - 1) + chunkProgress) / state.totalChunks)
              .clamp(0.0, 1.0)
              .toDouble();
      statusText =
          "Mengunduh bagian ${state.currentChunk} dari ${state.totalChunks} (${state.progress.percentage.toInt()}%)";
      statusColor = AppColors.tealGreen;
    } else if (state is DownloadSuccess) {
      isDownloaded = state.message.contains("berhasil diunduh") ||
          state.message.contains("sudah diunduh");
      progress = isDownloaded ? 1 : 0;
      statusText = state.message;
      statusColor = isDownloaded ? Colors.green : Colors.grey[600];
    } else if (state is DownloadFailure) {
      hasFailure = true;
      statusText = state.message;
      statusColor = Colors.red;
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSize.s16.r),
        border: Border.all(color: AppColors.darkTeal.withAlpha(14)),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppPadding.p16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44.r,
                  height: 44.r,
                  decoration: BoxDecoration(
                    color: AppColors.lemonYellow.withAlpha(55),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(Symbols.menu_book, color: AppColors.tealGreen, size: 24.sp),
                ),
                SizedBox(width: 12.w),
                const Expanded(
                  child: Text(
                    "Data Al-Quran",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppColors.darkerTeal,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            if (!isDownloaded || isDownloading)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: LinearProgressIndicator(
                  value: isLoading ? null : progress,
                  minHeight: 10.h,
                  backgroundColor: AppColors.tealGreen.withAlpha(22),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.tealGreen),
                ),
              ),
            SizedBox(height: 8.h),
            Text(statusText, style: TextStyle(color: statusColor, fontSize: 13)),
            SizedBox(height: 16.h),
            Row(
              children: [
                if (!isDownloaded && !isDownloading)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => DownloadPromptDialog(
                            featureName: "Al-Quran",
                            description: "Unduh data mushaf untuk akses offline.",
                            totalSize: "120 MB",
                            onDownload: () {
                              context.read<DownloadCubit>().startQuranDownload();
                            },
                          ),
                        );
                      },
                      icon: const Icon(Symbols.download),
                      label: Text(hasFailure ? "Coba Lagi" : "Unduh"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.tealGreen,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: AppPadding.p12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSize.s14.r),
                        ),
                      ),
                    ),
                  ),
                if (isDownloading)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: null,
                      icon: const Icon(Symbols.downloading),
                      label: const Text("Mengunduh..."),
                      style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: AppColors.tealGreen.withAlpha(40),
                        disabledForegroundColor: AppColors.darkerTeal.withAlpha(130),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: AppPadding.p12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSize.s14.r),
                        ),
                      ),
                    ),
                  ),
                if (isDownloaded)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _confirmDeleteQuran(context),
                      icon: const Icon(Symbols.delete, color: Color(0xFFB3261E)),
                      label: const Text(
                        "Hapus Data",
                        style: TextStyle(color: Color(0xFFB3261E)),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFB3261E)),
                        padding: EdgeInsets.symmetric(vertical: AppPadding.p12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSize.s14.r),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncContentCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSize.s16.r),
        border: Border.all(color: AppColors.darkTeal.withAlpha(14)),
      ),
      child: ListTile(
        enabled: false,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: Icon(Icons.sync_disabled, color: AppColors.darkerTeal.withAlpha(110), size: 28.sp),
        title: const Text(
          "Pembaruan Konten",
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.darkerTeal),
        ),
        subtitle: Text(
          "Sinkronisasi konten belum tersedia di rilis ini",
          style: TextStyle(color: AppColors.darkerTeal.withAlpha(130)),
        ),
        trailing: Icon(Icons.lock_outline, color: AppColors.darkerTeal.withAlpha(110)),
      ),
    );
  }

  Widget _buildCleanupCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSize.s16.r),
        border: Border.all(color: AppColors.darkTeal.withAlpha(14)),
      ),
      child: ListTile(
        enabled: false,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: Icon(Symbols.cleaning_services, color: AppColors.darkerTeal.withAlpha(110), size: 28.sp),
        title: const Text(
          "Bersihkan Cache",
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.darkerTeal),
        ),
        subtitle: Text(
          "Pembersihan cache belum tersedia di rilis ini",
          style: TextStyle(color: AppColors.darkerTeal.withAlpha(130)),
        ),
        trailing: Icon(Icons.lock_outline, color: AppColors.darkerTeal.withAlpha(110)),
      ),
    );
  }

  void _confirmDeleteQuran(BuildContext context) {
    final cubit = context.read<DownloadCubit>();

    showDialog(
      context: context,
      builder: (diagContext) => AlertDialog(
        title: const Text("Hapus Data Al-Quran?"),
        content: const Text("Anda harus mengunduh ulang data jika ingin membaca Al-Quran offline."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(diagContext), child: const Text("Batal")),
          TextButton(
            onPressed: () {
              cubit.clearQuranData();
              Navigator.pop(diagContext);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
