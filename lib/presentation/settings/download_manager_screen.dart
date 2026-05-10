import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../app/resources/resources.dart';
import '../../di/di.dart';
import '../../domain/models/download/download_manifest.dart';
import '../download/cubit/download_cubit.dart';
import '../download/cubit/download_state.dart';

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
        body: BlocConsumer<DownloadCubit, DownloadState>(
          listener: (context, state) {
            if (state is DownloadSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is DownloadFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: const Color(0xFFB3261E),
                ),
              );
            }
          },
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
    final manifest = _manifestFrom(state);
    final downloadedChunks = _downloadedChunksFrom(state);

    if (state is DownloadManifestLoading || state is DownloadInitial) {
      return const _CardShell(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (manifest == null) {
      return _CardShell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Data Al-Quran",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: AppColors.darkerTeal,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              state is DownloadFailure
                  ? state.message
                  : "Informasi paket mushaf belum tersedia.",
              style: TextStyle(color: AppColors.darkerTeal.withAlpha(170)),
            ),
            SizedBox(height: 12.h),
            ElevatedButton.icon(
              onPressed: () => context.read<DownloadCubit>().checkManifest(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text("Muat Ulang"),
            ),
          ],
        ),
      );
    }

    return _CardShell(
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
                child: Icon(
                  Symbols.menu_book,
                  color: AppColors.tealGreen,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              const Expanded(
                child: Text(
                  "Paket Mushaf Al-Quran",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.darkerTeal,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            "Unduh sesuai kebutuhan. Setiap paket berisi sekitar 10 juz.",
            style: TextStyle(
              color: AppColors.darkerTeal.withAlpha(160),
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 14.h),
          for (final chunk in manifest.quran.chunks) ...[
            _QuranPackageTile(
              chunk: chunk,
              isDownloaded: downloadedChunks.contains(chunk.id),
              isBusy: state is DownloadProgressState,
              isDownloading:
                  state is DownloadProgressState &&
                  state.activeChunkId == chunk.id,
              progress:
                  state is DownloadProgressState &&
                      state.activeChunkId == chunk.id
                  ? (state.progress.percentage / 100).clamp(0.0, 1.0)
                  : 0,
              onDownload: () =>
                  context.read<DownloadCubit>().downloadQuranChunk(chunk),
              onDelete: () => _confirmDeleteQuranChunk(context, chunk),
            ),
            if (chunk != manifest.quran.chunks.last) SizedBox(height: 10.h),
          ],
        ],
      ),
    );
  }

  DownloadManifest? _manifestFrom(DownloadState state) {
    if (state is DownloadManifestLoaded) return state.manifest;
    if (state is DownloadProgressState) return state.manifest;
    return null;
  }

  List<String> _downloadedChunksFrom(DownloadState state) {
    if (state is DownloadManifestLoaded) return state.downloadedChunks;
    if (state is DownloadProgressState) return state.downloadedChunks;
    return const [];
  }

  Widget _buildSyncContentCard() {
    return _DisabledTile(
      icon: Icons.sync_disabled,
      title: "Pembaruan Konten",
      subtitle: "Sinkronisasi konten belum tersedia di rilis ini",
    );
  }

  Widget _buildCleanupCard() {
    return _DisabledTile(
      icon: Symbols.cleaning_services,
      title: "Bersihkan Cache",
      subtitle: "Pembersihan cache belum tersedia di rilis ini",
    );
  }

  void _confirmDeleteQuranChunk(BuildContext context, QuranChunk chunk) {
    final cubit = context.read<DownloadCubit>();

    showDialog(
      context: context,
      builder: (diagContext) => AlertDialog(
        title: Text("Hapus ${chunk.title}?"),
        content: Text(
          "Paket halaman ${chunk.startPage}-${chunk.endPage} akan dihapus.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(diagContext),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(diagContext);
              cubit.deleteQuranChunk(chunk);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _QuranPackageTile extends StatelessWidget {
  final QuranChunk chunk;
  final bool isDownloaded;
  final bool isBusy;
  final bool isDownloading;
  final double progress;
  final VoidCallback onDownload;
  final VoidCallback onDelete;

  const _QuranPackageTile({
    required this.chunk,
    required this.isDownloaded,
    required this.isBusy,
    required this.isDownloading,
    required this.progress,
    required this.onDownload,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.darkTeal.withAlpha(12)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 38.r,
                height: 38.r,
                decoration: BoxDecoration(
                  color: isDownloaded
                      ? AppColors.tealGreen.withAlpha(28)
                      : AppColors.lemonYellow.withAlpha(48),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isDownloaded
                      ? Icons.check_rounded
                      : Symbols.download_for_offline,
                  color: AppColors.tealGreen,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chunk.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkerTeal,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      "${chunk.subtitle} - Halaman ${chunk.startPage}-${chunk.endPage}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.darkerTeal.withAlpha(150),
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              _PackageActionButton(
                isDownloaded: isDownloaded,
                isBusy: isBusy,
                isDownloading: isDownloading,
                onDownload: onDownload,
                onDelete: onDelete,
              ),
            ],
          ),
          if (isDownloading) ...[
            SizedBox(height: 10.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8.h,
                backgroundColor: AppColors.tealGreen.withAlpha(22),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.tealGreen,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PackageActionButton extends StatelessWidget {
  final bool isDownloaded;
  final bool isBusy;
  final bool isDownloading;
  final VoidCallback onDownload;
  final VoidCallback onDelete;

  const _PackageActionButton({
    required this.isDownloaded,
    required this.isBusy,
    required this.isDownloading,
    required this.onDownload,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (isDownloading || isBusy) {
      return SizedBox(
        width: 82,
        child: Text(
          isDownloading ? "Mengunduh" : "Menunggu",
          textAlign: TextAlign.end,
        ),
      );
    }

    if (isDownloaded) {
      return IconButton(
        onPressed: onDelete,
        tooltip: "Hapus paket",
        icon: const Icon(Icons.delete_outline, color: Color(0xFFB3261E)),
      );
    }

    return TextButton(onPressed: onDownload, child: const Text("Unduh"));
  }
}

class _CardShell extends StatelessWidget {
  final Widget child;

  const _CardShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSize.s16.r),
        border: Border.all(color: AppColors.darkTeal.withAlpha(14)),
      ),
      child: Padding(padding: EdgeInsets.all(AppPadding.p16.r), child: child),
    );
  }
}

class _DisabledTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _DisabledTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: ListTile(
        enabled: false,
        contentPadding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 2.h),
        leading: Icon(
          icon,
          color: AppColors.darkerTeal.withAlpha(110),
          size: 28.sp,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.darkerTeal,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: AppColors.darkerTeal.withAlpha(130)),
        ),
        trailing: Icon(
          Icons.lock_outline,
          color: AppColors.darkerTeal.withAlpha(110),
        ),
      ),
    );
  }
}
