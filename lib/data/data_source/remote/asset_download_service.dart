import 'dart:convert';
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

  static const Map<String, Map<String, dynamic>> _quranChunkOverrides = {
    'part1': {
      'id': 'quran-juz-01-10',
      'title': 'Paket 1',
      'subtitle': 'Paket awal mushaf',
      'url':
          'https://github.com/keirelliot12/annibros-assets/releases/download/1.0/quran-part1.zip',
      'startJuz': 1,
      'endJuz': 10,
    },
    'quran-juz-01-10': {
      'id': 'quran-juz-01-10',
      'title': 'Paket 1',
      'subtitle': 'Paket awal mushaf',
      'url':
          'https://github.com/keirelliot12/annibros-assets/releases/download/1.0/quran-part1.zip',
      'startJuz': 1,
      'endJuz': 10,
    },
    'part2': {
      'id': 'quran-juz-11-20',
      'title': 'Paket 2',
      'subtitle': 'Paket tengah mushaf',
      'url':
          'https://github.com/keirelliot12/annibros-assets/releases/download/1.0/quran-part2.zip',
      'startJuz': 11,
      'endJuz': 20,
    },
    'quran-juz-11-20': {
      'id': 'quran-juz-11-20',
      'title': 'Paket 2',
      'subtitle': 'Paket tengah mushaf',
      'url':
          'https://github.com/keirelliot12/annibros-assets/releases/download/1.0/quran-part2.zip',
      'startJuz': 11,
      'endJuz': 20,
    },
    'part3': {
      'id': 'quran-juz-21-30',
      'title': 'Paket 3',
      'subtitle': 'Paket akhir mushaf',
      'url':
          'https://github.com/keirelliot12/annibros-assets/releases/download/1.0/quran-part3.zip',
      'startJuz': 21,
      'endJuz': 30,
    },
    'quran-juz-21-30': {
      'id': 'quran-juz-21-30',
      'title': 'Paket 3',
      'subtitle': 'Paket akhir mushaf',
      'url':
          'https://github.com/keirelliot12/annibros-assets/releases/download/1.0/quran-part3.zip',
      'startJuz': 21,
      'endJuz': 30,
    },
  };

  AssetDownloadService(this._dio, this._storageManager);

  /// Mock manifest untuk development/testing di web (CORS issues)
  static Map<String, dynamic> _getMockManifest() {
    return {
      'version': '1.0.0',
      'lastUpdated': '2026-05-09',
      'quran': {
        'version': '1.0.0',
        'totalPages': 604,
        'chunks': [
          {
            'id': 'quran-juz-01-10',
            'title': 'Paket 1',
            'subtitle': 'Paket awal mushaf',
            'url':
                'https://github.com/keirelliot12/annibros-assets/releases/download/1.0/quran-part1.zip',
            'startJuz': 1,
            'endJuz': 10,
            'startPage': 1,
            'endPage': 200,
            'sizeBytes': 38008621,
            'checksum': '',
          },
          {
            'id': 'quran-juz-11-20',
            'title': 'Paket 2',
            'subtitle': 'Paket tengah mushaf',
            'url':
                'https://github.com/keirelliot12/annibros-assets/releases/download/1.0/quran-part2.zip',
            'startJuz': 11,
            'endJuz': 20,
            'startPage': 201,
            'endPage': 400,
            'sizeBytes': 39773069,
            'checksum': '',
          },
          {
            'id': 'quran-juz-21-30',
            'title': 'Paket 3',
            'subtitle': 'Paket akhir mushaf',
            'url':
                'https://github.com/keirelliot12/annibros-assets/releases/download/1.0/quran-part3.zip',
            'startJuz': 21,
            'endJuz': 30,
            'startPage': 401,
            'endPage': 604,
            'sizeBytes': 41749430,
            'checksum': '',
          },
        ],
      },
    };
  }

  Future<DownloadManifest> fetchManifest() async {
    try {
      developer.log('📥 Fetching manifest from: $_manifestUrl');

      try {
        final response = await _dio.get(_manifestUrl);
        final responseData = response.data is String
            ? jsonDecode(response.data as String) as Map<String, dynamic>
            : Map<String, dynamic>.from(response.data as Map);
        final manifest = DownloadManifest.fromJson(
          _normalizeManifestJson(responseData),
        );
        developer.log(
          '✅ Manifest fetched successfully. Version: ${manifest.version}',
        );
        return manifest;
      } catch (e) {
        // CORS error atau network error
        developer.log('⚠️ Error fetching from GitHub: $e');

        // Fallback ke mock untuk web testing
        if (kIsWeb) {
          developer.log(
            '📌 Using mock manifest untuk web development (CORS bypass)',
          );
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

  static Map<String, dynamic> _normalizeManifestJson(
    Map<String, dynamic> json,
  ) {
    final normalized = Map<String, dynamic>.from(json);
    final quran = Map<String, dynamic>.from(normalized['quran'] as Map);
    final chunks = (quran['chunks'] as List)
        .map(
          (chunk) =>
              _normalizeQuranChunkJson(Map<String, dynamic>.from(chunk as Map)),
        )
        .toList();

    quran['chunks'] = chunks;
    normalized['quran'] = quran;
    return normalized;
  }

  static Map<String, dynamic> _normalizeQuranChunkJson(
    Map<String, dynamic> chunk,
  ) {
    final rawId = chunk['id']?.toString() ?? '';
    final override = _quranChunkOverrides[rawId];
    if (override == null) return chunk;

    return {...chunk, ...override};
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
          onProgress(
            DownloadProgress(
              chunkId: chunk.id,
              bytesReceived: received,
              totalBytes: total,
              percentage: (received / total) * 100,
              state: DownloadState.downloading,
            ),
          );
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
        final fileName = _safeQuranPageFileName(file.name);
        if (fileName == null) {
          developer.log('Skipping unexpected Quran ZIP entry: ${file.name}');
          continue;
        }
        final data = file.content as List<int>;
        File('${quranDir.path}/$fileName')
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      }
    }

    // Cleanup temp ZIP
    await File(zipPath).delete();

    // Mark as downloaded
    await _storageManager.markChunkDownloaded(chunk.id);

    onProgress(
      DownloadProgress(
        chunkId: chunk.id,
        bytesReceived: chunk.sizeBytes,
        totalBytes: chunk.sizeBytes,
        percentage: 100,
        state: DownloadState.completed,
      ),
    );
  }

  String? _safeQuranPageFileName(String rawName) {
    final normalized = rawName.replaceAll('\\', '/');
    if (normalized.startsWith('/') || normalized.contains(':')) return null;

    final parts = normalized.split('/').where((part) => part.isNotEmpty);
    if (parts.any((part) => part == '..')) return null;

    final fileName = parts.isEmpty ? '' : parts.last;
    final pagePattern = RegExp(r'^page\d{3}\.png$');
    return pagePattern.hasMatch(fileName) ? fileName : null;
  }
}
