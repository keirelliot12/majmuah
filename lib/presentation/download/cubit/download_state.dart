import 'package:equatable/equatable.dart';
import '../../../domain/models/download/download_manifest.dart';
import '../../../domain/models/download/download_status.dart';

abstract class DownloadState extends Equatable {
  const DownloadState();

  @override
  List<Object?> get props => [];
}

class DownloadInitial extends DownloadState {}

class DownloadManifestLoading extends DownloadState {}

class DownloadManifestLoaded extends DownloadState {
  final DownloadManifest manifest;
  final List<String> downloadedChunks;
  final String? currentVersion;

  const DownloadManifestLoaded({
    required this.manifest,
    required this.downloadedChunks,
    this.currentVersion,
  });

  bool get isQuranFullyDownloaded => manifest.quran.chunks.every(
    (chunk) => downloadedChunks.contains(chunk.id),
  );

  bool get isUpdateAvailable => manifest.version != currentVersion;

  @override
  List<Object?> get props => [manifest, downloadedChunks, currentVersion];
}

class DownloadProgressState extends DownloadState {
  final DownloadProgress progress;
  final int currentChunk;
  final int totalChunks;
  final DownloadManifest? manifest;
  final List<String> downloadedChunks;
  final String? activeChunkId;

  const DownloadProgressState({
    required this.progress,
    required this.currentChunk,
    required this.totalChunks,
    this.manifest,
    this.downloadedChunks = const [],
    this.activeChunkId,
  });

  @override
  List<Object?> get props => [
    progress,
    currentChunk,
    totalChunks,
    manifest,
    downloadedChunks,
    activeChunkId,
  ];
}

class DownloadSuccess extends DownloadState {
  final String message;
  const DownloadSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class DownloadFailure extends DownloadState {
  final String message;
  const DownloadFailure(this.message);

  @override
  List<Object?> get props => [message];
}
