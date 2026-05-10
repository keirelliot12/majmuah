import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import '../../../../data/data_source/local/download_storage_manager.dart';
import '../../../../data/data_source/remote/asset_download_service.dart';
import '../../../../domain/models/download/download_manifest.dart';
import '../../../../domain/models/download/download_status.dart'
    as download_status;
import 'download_state.dart';

class DownloadCubit extends Cubit<DownloadState> {
  final AssetDownloadService _downloadService;
  final DownloadStorageManager _storageManager;
  bool _isDownloading = false;

  DownloadCubit(this._downloadService, this._storageManager)
    : super(DownloadInitial());

  static DownloadCubit get(context) => BlocProvider.of(context);

  Future<void> checkManifest() async {
    emit(DownloadManifestLoading());
    try {
      developer.log('🔍 Checking manifest...');
      final manifest = await _downloadService.fetchManifest();
      final downloadedChunks = await _verifiedDownloadedChunks(manifest);
      final currentVersion = await _storageManager.getCurrentManifestVersion();

      developer.log('📊 Manifest Check Results:');
      developer.log('  • Remote version: ${manifest.version}');
      developer.log('  • Local version: $currentVersion');
      developer.log('  • Downloaded chunks: ${downloadedChunks.length}');
      developer.log(
        '  • Update available: ${manifest.version != currentVersion}',
      );

      emit(
        DownloadManifestLoaded(
          manifest: manifest,
          downloadedChunks: downloadedChunks,
          currentVersion: currentVersion,
        ),
      );

      developer.log('✅ Manifest check complete');
    } catch (e) {
      developer.log('❌ Error checking manifest: $e');
      emit(DownloadFailure("Gagal memuat informasi unduhan: $e"));
    }
  }

  Future<void> startQuranDownload() async {
    if (_isDownloading) return;

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
        _isDownloading = true;
        final manifestChunkIds = manifest.quran.chunks
            .map((chunk) => chunk.id)
            .toSet();
        int completed = manifestState.downloadedChunks
            .where((chunkId) => manifestChunkIds.contains(chunkId))
            .length;
        int total = manifest.quran.chunks.length;

        for (var chunk in chunksToDownload) {
          await _downloadService.downloadQuranChunk(
            chunk: chunk,
            onProgress: (progress) {
              emit(
                DownloadProgressState(
                  progress: progress,
                  currentChunk: completed + 1,
                  totalChunks: total,
                  manifest: manifest,
                  downloadedChunks: manifestState.downloadedChunks,
                  activeChunkId: chunk.id,
                ),
              );
            },
          );
          completed++;
        }

        // Save the original manifest version after every chunk completes.
        await _storageManager.saveManifestVersion(manifest.version);

        emit(const DownloadSuccess("Al-Quran berhasil diunduh."));
      } catch (e) {
        emit(DownloadFailure("Gagal mengunduh Al-Quran: $e"));
      } finally {
        _isDownloading = false;
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

  Future<void> downloadQuranChunk(QuranChunk chunk) async {
    if (_isDownloading) return;

    DownloadManifest? manifest;
    List<String> downloadedChunks = const [];

    if (state is DownloadManifestLoaded) {
      final loadedState = state as DownloadManifestLoaded;
      manifest = loadedState.manifest;
      downloadedChunks = loadedState.downloadedChunks;
    } else if (state is DownloadProgressState) {
      final progressState = state as DownloadProgressState;
      manifest = progressState.manifest;
      downloadedChunks = progressState.downloadedChunks;
    }

    try {
      _isDownloading = true;
      emit(
        DownloadProgressState(
          progress: download_status.DownloadProgress(
            chunkId: chunk.id,
            bytesReceived: 0,
            totalBytes: chunk.sizeBytes,
            percentage: 0,
            state: download_status.DownloadState.downloading,
          ),
          currentChunk: 1,
          totalChunks: 1,
          manifest: manifest,
          downloadedChunks: downloadedChunks,
          activeChunkId: chunk.id,
        ),
      );

      await _downloadService.downloadQuranChunk(
        chunk: chunk,
        onProgress: (progress) {
          emit(
            DownloadProgressState(
              progress: progress,
              currentChunk: 1,
              totalChunks: 1,
              manifest: manifest,
              downloadedChunks: downloadedChunks,
              activeChunkId: chunk.id,
            ),
          );
        },
      );

      if (manifest != null) {
        await _storageManager.saveManifestVersion(manifest.version);
      }

      emit(DownloadSuccess('${chunk.title} berhasil diunduh.'));
      await checkManifest();
    } catch (e) {
      emit(DownloadFailure('Gagal mengunduh ${chunk.title}: $e'));
    } finally {
      _isDownloading = false;
    }
  }

  Future<void> deleteQuranChunk(QuranChunk chunk) async {
    try {
      await _storageManager.deletePageRange(
        chunkId: chunk.id,
        startPage: chunk.startPage,
        endPage: chunk.endPage,
      );
      emit(DownloadSuccess('${chunk.title} berhasil dihapus.'));
      await checkManifest();
    } catch (e) {
      emit(DownloadFailure('Gagal menghapus ${chunk.title}: $e'));
    }
  }

  Future<List<String>> _verifiedDownloadedChunks(
    DownloadManifest manifest,
  ) async {
    final rawDownloadedChunks = await _storageManager.getDownloadedChunks();
    final verified = <String>[];

    for (final chunk in manifest.quran.chunks) {
      if (!rawDownloadedChunks.contains(chunk.id)) continue;

      final isAvailable = await _storageManager.isPageRangeAvailable(
        chunk.startPage,
        chunk.endPage,
      );
      if (isAvailable) {
        verified.add(chunk.id);
      } else {
        await _storageManager.unmarkChunkDownloaded(chunk.id);
      }
    }

    return verified;
  }
}
