enum DownloadState {
  idle,
  downloading,
  paused,
  completed,
  error,
}

class DownloadProgress {
  final String chunkId;
  final int bytesReceived;
  final int totalBytes;
  final double percentage;
  final DownloadState state;

  DownloadProgress({
    required this.chunkId,
    required this.bytesReceived,
    required this.totalBytes,
    required this.percentage,
    required this.state,
  });
}

enum FeatureDownloadStatus {
  notDownloaded,
  partiallyDownloaded,
  fullyDownloaded,
  updateAvailable,
}
