import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import '../../../../data/data_source/local/download_storage_manager.dart';
import '../../../../data/data_source/remote/asset_download_service.dart';
import 'download_state.dart';

class DownloadCubit extends Cubit<DownloadState> {
  final AssetDownloadService _downloadService;
  final DownloadStorageManager _storageManager;

  DownloadCubit(this._downloadService, this._storageManager) : super(DownloadInitial());

  static DownloadCubit get(context) => BlocProvider.of(context);

  Future<void> checkManifest() async {
    emit(DownloadManifestLoading());
    try {
      developer.log('🔍 Checking manifest...');
      final manifest = await _downloadService.fetchManifest();
      final downloadedChunks = await _storageManager.getDownloadedChunks();
      final currentVersion = await _storageManager.getCurrentManifestVersion();

      developer.log('📊 Manifest Check Results:');
      developer.log('  • Remote version: ${manifest.version}');
      developer.log('  • Local version: $currentVersion');
      developer.log('  • Downloaded chunks: ${downloadedChunks.length}');
      developer.log('  • Update available: ${manifest.version != currentVersion}');

      emit(DownloadManifestLoaded(
        manifest: manifest,
        downloadedChunks: downloadedChunks,
        currentVersion: currentVersion,
      ));

      developer.log('✅ Manifest check complete');
    } catch (e) {
      developer.log('❌ Error checking manifest: $e');
      emit(DownloadFailure("Gagal memuat informasi unduhan: $e"));
    }
  }

  Future<void> startQuranDownload() async {
    if (state is! DownloadManifestLoaded) {
      await checkManifest();
    }

    if (state is DownloadManifestLoaded) {
      final manifestState = state as DownloadManifestLoaded;
      final manifest = manifestState.manifest;
      final chunksToDownload = manifest.quran.chunks
          .where((c) => !manifestState.downloadedChunks.contains(c.id))
          .toList();

      if (chunksToDownload.isEmpty) {
        await _storageManager.saveManifestVersion(manifest.version);
        emit(const DownloadSuccess("Al-Quran sudah diunduh sepenuhnya."));
        return;
      }

      try {
        final manifestChunkIds = manifest.quran.chunks.map((chunk) => chunk.id).toSet();
        int completed = manifestState.downloadedChunks
            .where((chunkId) => manifestChunkIds.contains(chunkId))
            .length;
        int total = manifest.quran.chunks.length;

        for (var chunk in chunksToDownload) {
          await _downloadService.downloadQuranChunk(
            chunk: chunk,
            onProgress: (progress) {
              emit(DownloadProgressState(
                progress: progress,
                currentChunk: completed + 1,
                totalChunks: total,
              ));
            },
          );
          completed++;
        }

        // Save the original manifest version after every chunk completes.
        await _storageManager.saveManifestVersion(manifest.version);

        emit(const DownloadSuccess("Al-Quran berhasil diunduh."));
      } catch (e) {
        emit(DownloadFailure("Gagal mengunduh Al-Quran: $e"));
      }
    }
  }

  Future<void> clearQuranData() async {
    try {
      await _storageManager.clearQuranData();
      emit(const DownloadSuccess("Data Al-Quran berhasil dihapus."));
      await checkManifest();
    } catch (e) {
      emit(DownloadFailure("Gagal menghapus data: $e"));
    }
  }
}
