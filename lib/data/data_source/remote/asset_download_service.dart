import 'dart:io';
import 'package:dio/dio.dart';
import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../local/download_storage_manager.dart';
import '../../../domain/models/download/download_manifest.dart';
import '../../../domain/models/download/download_status.dart';
import 'dart:developer' as developer;

class AssetDownloadService {
  final Dio _dio;
  final DownloadStorageManager _storageManager;

  // Actual URL for the manifest from GitHub Releases
  static const String _manifestUrl =
    'https://github.com/keirelliot12/annibros-assets/releases/download/1.0/manifest.json';

  AssetDownloadService(this._dio, this._storageManager);

  /// Mock manifest untuk development/testing di web (CORS issues)
  static Map<String, dynamic> _getMockManifest() {
    return {
      'version': '1.0.0',
      'quran': {
        'chunks': [
          {'id': 'quran-part1', 'url': 'https://example.com/quran-part1.zip'},
          {'id': 'quran-part2', 'url': 'https://example.com/quran-part2.zip'},
          {'id': 'quran-part3', 'url': 'https://example.com/quran-part3.zip'},
        ]
      }
    };
  }

  Future<DownloadManifest> fetchManifest() async {
    try {
      developer.log('📥 Fetching manifest from: $_manifestUrl');

      try {
        final response = await _dio.get(_manifestUrl);
        final manifest = DownloadManifest.fromJson(response.data);
        developer.log('✅ Manifest fetched successfully. Version: ${manifest.version}');
        return manifest;
      } catch (e) {
        // CORS error atau network error
        developer.log('⚠️ Error fetching from GitHub: $e');

        // Fallback ke mock untuk web testing
        if (kIsWeb) {
          developer.log('📌 Using mock manifest untuk web development (CORS bypass)');
          final manifest = DownloadManifest.fromJson(_getMockManifest());
          developer.log('✅ Mock manifest loaded. Version: ${manifest.version}');
          return manifest;
        }

        rethrow;
      }
    } catch (e) {
      developer.log('❌ Final error fetching manifest: $e');
      rethrow;
    }
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
