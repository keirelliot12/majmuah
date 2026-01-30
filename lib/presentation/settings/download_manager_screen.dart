import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../app/resources/color_manager.dart';
import '../../app/resources/values_manager.dart';
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
        appBar: AppBar(
          title: const Text("Kelola Unduhan"),
          centerTitle: true,
        ),
        body: BlocBuilder<DownloadCubit, DownloadState>(
          builder: (context, state) {
            return ListView(
              padding: EdgeInsets.all(AppPadding.p16.r),
              children: [
                _buildQuranDownloadCard(context, state),
                SizedBox(height: AppSize.s16.h),
                _buildSyncContentCard(context, state),
                SizedBox(height: AppSize.s16.h),
                _buildCleanupCard(context),
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

    if (state is DownloadManifestLoaded) {
      isDownloaded = state.isQuranFullyDownloaded;
      int downloadedCount = state.downloadedChunks.length;
      int totalChunks = state.manifest.quran.chunks.length;
      progress = downloadedCount / totalChunks;
      statusText = isDownloaded
          ? "Semua halaman sudah terunduh"
          : "$downloadedCount dari $totalChunks bagian terunduh";
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s16.r)),
      child: Padding(
        padding: EdgeInsets.all(AppPadding.p16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Symbols.menu_book, color: ColorManager.gold, size: 28.sp),
                SizedBox(width: 12.w),
                const Text(
                  "Data Al-Quran",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            if (!isDownloaded) LinearProgressIndicator(value: progress),
            SizedBox(height: 8.h),
            Text(statusText, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
            SizedBox(height: 16.h),
            Row(
              children: [
                if (!isDownloaded)
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
                      label: const Text("Unduh"),
                    ),
                  ),
                if (isDownloaded)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _confirmDeleteQuran(context),
                      icon: const Icon(Symbols.delete, color: Colors.red),
                      label: const Text("Hapus Data", style: TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncContentCard(BuildContext context, DownloadState state) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s16.r)),
      child: ListTile(
        leading: Icon(Symbols.sync, color: Colors.blue, size: 28.sp),
        title: const Text("Pembaruan Konten", style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text("Khutbah, Maulid, Kata Mutiara..."),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Implement sync logic
        },
      ),
    );
  }

  Widget _buildCleanupCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s16.r)),
      child: ListTile(
        leading: Icon(Symbols.cleaning_services, color: Colors.orange, size: 28.sp),
        title: const Text("Bersihkan Cache", style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text("Hapus file sementara aplikasi"),
        onTap: () {
          // Implement cache cleaning
        },
      ),
    );
  }

  void _confirmDeleteQuran(BuildContext context) {
    showDialog(
      context: context,
      builder: (diagContext) => AlertDialog(
        title: const Text("Hapus Data Al-Quran?"),
        content: const Text("Anda harus mengunduh ulang data jika ingin membaca Al-Quran offline."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(diagContext), child: const Text("Batal")),
          TextButton(
            onPressed: () {
              // Note: Use parent context to access Cubit
              // storage manager direct deletion usually better or via Cubit
              Navigator.pop(diagContext);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
