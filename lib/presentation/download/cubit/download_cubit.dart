import 'package:flutter_bloc/flutter_bloc.dart';
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
      final manifest = await _downloadService.fetchManifest();
      final downloadedChunks = await _storageManager.getDownloadedChunks();
      emit(DownloadManifestLoaded(
        manifest: manifest,
        downloadedChunks: downloadedChunks,
      ));
    } catch (e) {
      emit(DownloadFailure("Gagal memuat informasi unduhan: $e"));
    }
  }

  Future<void> startQuranDownload() async {
    if (state is! DownloadManifestLoaded) {
      await checkManifest();
    }

    if (state is DownloadManifestLoaded) {
      final manifestState = state as DownloadManifestLoaded;
      final chunksToDownload = manifestState.manifest.quran.chunks
          .where((c) => !manifestState.downloadedChunks.contains(c.id))
          .toList();

      if (chunksToDownload.isEmpty) {
        emit(const DownloadSuccess("Al-Quran sudah diunduh sepenuhnya."));
        return;
      }

      try {
        int completed = manifestState.downloadedChunks.length;
        int total = manifestState.manifest.quran.chunks.length;

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
        emit(const DownloadSuccess("Al-Quran berhasil diunduh."));
        // Final check to update status
        checkManifest();
      } catch (e) {
        emit(DownloadFailure("Gagal mengunduh Al-Quran: $e"));
      }
    }
  }
}
