import 'dart:io';
import 'package:dio/dio.dart';
import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import '../local/download_storage_manager.dart';
import '../../../domain/models/download/download_manifest.dart';
import '../../../domain/models/download/download_status.dart';

class AssetDownloadService {
  final Dio _dio;
  final DownloadStorageManager _storageManager;

  // Actual URL for the manifest from GitHub Releases
  static const String _manifestUrl =
    'https://github.com/keirelliot12/annibros-assets/releases/download/1.0/manifest.json';

  AssetDownloadService(this._dio, this._storageManager);

  Future<DownloadManifest> fetchManifest() async {
    final response = await _dio.get(_manifestUrl);
    return DownloadManifest.fromJson(response.data);
  }

  Future<void> downloadQuranChunk({
    required QuranChunk chunk,
    required Function(DownloadProgress) onProgress,
    CancelToken? cancelToken,
  }) async {
    final tempDir = await getTemporaryDirectory();
    final zipPath = '${tempDir.path}/${chunk.id}.zip';

    // Download ZIP
    await _dio.download(
      chunk.url,
      zipPath,
      cancelToken: cancelToken,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          onProgress(DownloadProgress(
            chunkId: chunk.id,
            bytesReceived: received,
            totalBytes: total,
            percentage: (received / total) * 100,
            state: DownloadState.downloading,
          ));
        }
      },
    );

    // Verify checksum if provided
    if (chunk.checksum.isNotEmpty && chunk.checksum.startsWith('sha256:')) {
      final file = File(zipPath);
      final bytes = await file.readAsBytes();
      final digest = sha256.convert(bytes);
      final expectedHash = chunk.checksum.substring(7);

      if (digest.toString() != expectedHash) {
        await file.delete();
        throw Exception('Checksum mismatch for ${chunk.id}');
      }
    }

    // Extract ZIP
    final quranDir = await _storageManager.quranDirectory;
    final bytes = File(zipPath).readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);

    for (final file in archive) {
      if (file.isFile) {
        final data = file.content as List<int>;
        File('${quranDir.path}/${file.name}')
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      }
    }

    // Cleanup temp ZIP
    await File(zipPath).delete();

    // Mark as downloaded
    await _storageManager.markChunkDownloaded(chunk.id);

    onProgress(DownloadProgress(
      chunkId: chunk.id,
      bytesReceived: chunk.sizeBytes,
      totalBytes: chunk.sizeBytes,
      percentage: 100,
      state: DownloadState.completed,
    ));
  }
}
