import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadStorageManager {
  static const String _quranDirName = 'quran_pages';
  static const String _downloadStatusKey = 'download_status';
  static const String _currentManifestVersionKey = 'current_manifest_version';

  final SharedPreferences _prefs;

  DownloadStorageManager(this._prefs);

  Future<Directory> get quranDirectory async {
    final appDir = await getApplicationDocumentsDirectory();
    final quranDir = Directory('${appDir.path}/$_quranDirName');
    if (!await quranDir.exists()) {
      await quranDir.create(recursive: true);
    }
    return quranDir;
  }

  Future<List<String>> getDownloadedChunks() async {
    return _prefs.getStringList(_downloadStatusKey) ?? [];
  }

  Future<void> markChunkDownloaded(String chunkId) async {
    final status = _prefs.getStringList(_downloadStatusKey) ?? [];
    if (!status.contains(chunkId)) {
      status.add(chunkId);
      await _prefs.setStringList(_downloadStatusKey, status);
    }
  }

  Future<void> unmarkChunkDownloaded(String chunkId) async {
    final status = _prefs.getStringList(_downloadStatusKey) ?? [];
    status.remove(chunkId);
    await _prefs.setStringList(_downloadStatusKey, status);
  }

  Future<String?> getQuranPagePath(int pageNumber) async {
    final quranDir = await quranDirectory;
    final fileName = 'page${pageNumber.toString().padLeft(3, '0')}.png';
    final file = File('${quranDir.path}/$fileName');

    if (await file.exists()) {
      return file.path;
    }
    return null;
  }

  Future<int> getDownloadedPagesCount() async {
    final quranDir = await quranDirectory;
    if (!await quranDir.exists()) return 0;

    final files = await quranDir.list().toList();
    return files.where((f) => f.path.endsWith('.png')).length;
  }

  Future<bool> isPageRangeAvailable(int startPage, int endPage) async {
    final quranDir = await quranDirectory;
    for (var page = startPage; page <= endPage; page++) {
      final fileName = 'page${page.toString().padLeft(3, '0')}.png';
      if (!await File('${quranDir.path}/$fileName').exists()) {
        return false;
      }
    }
    return true;
  }

  Future<void> deletePageRange({
    required String chunkId,
    required int startPage,
    required int endPage,
  }) async {
    final quranDir = await quranDirectory;
    for (var page = startPage; page <= endPage; page++) {
      final fileName = 'page${page.toString().padLeft(3, '0')}.png';
      final file = File('${quranDir.path}/$fileName');
      if (await file.exists()) {
        await file.delete();
      }
    }
    await unmarkChunkDownloaded(chunkId);
  }

  Future<void> clearQuranData() async {
    final quranDir = await quranDirectory;
    if (await quranDir.exists()) {
      await quranDir.delete(recursive: true);
    }
    await _prefs.remove(_downloadStatusKey);
  }

  Future<String?> getCurrentManifestVersion() async {
    return _prefs.getString(_currentManifestVersionKey);
  }

  Future<void> saveManifestVersion(String version) async {
    await _prefs.setString(_currentManifestVersionKey, version);
  }
}
