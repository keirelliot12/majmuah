class DownloadManifest {
  final String version;
  final String lastUpdated;
  final QuranManifest quran;

  DownloadManifest({
    required this.version,
    required this.lastUpdated,
    required this.quran,
  });

  factory DownloadManifest.fromJson(Map<String, dynamic> json) {
    return DownloadManifest(
      version: json['version'],
      lastUpdated: json['lastUpdated'],
      quran: QuranManifest.fromJson(json['quran']),
    );
  }
}

class QuranManifest {
  final String version;
  final int totalPages;
  final List<QuranChunk> chunks;

  QuranManifest({
    required this.version,
    required this.totalPages,
    required this.chunks,
  });

  factory QuranManifest.fromJson(Map<String, dynamic> json) {
    return QuranManifest(
      version: json['version'],
      totalPages: json['totalPages'],
      chunks: (json['chunks'] as List)
          .map((i) => QuranChunk.fromJson(i))
          .toList(),
    );
  }
}

class QuranChunk {
  final String id;
  final String url;
  final int startPage;
  final int endPage;
  final int sizeBytes;
  final String checksum;
  final String title;
  final String subtitle;
  final int startJuz;
  final int endJuz;

  QuranChunk({
    required this.id,
    required this.url,
    required this.startPage,
    required this.endPage,
    required this.sizeBytes,
    required this.checksum,
    required this.title,
    required this.subtitle,
    required this.startJuz,
    required this.endJuz,
  });

  factory QuranChunk.fromJson(Map<String, dynamic> json) {
    final startJuz = json['startJuz'] ?? 1;
    final endJuz = json['endJuz'] ?? startJuz;
    final startPage = json['startPage'] ?? 1;
    final endPage = json['endPage'] ?? startPage;

    return QuranChunk(
      id: json['id'],
      url: json['url'],
      startPage: startPage,
      endPage: endPage,
      sizeBytes: json['sizeBytes'] ?? 0,
      checksum: json['checksum'] ?? '',
      title: json['title'] ?? 'Juz $startJuz-$endJuz',
      subtitle: json['subtitle'] ?? 'Halaman $startPage-$endPage',
      startJuz: startJuz,
      endJuz: endJuz,
    );
  }
}
