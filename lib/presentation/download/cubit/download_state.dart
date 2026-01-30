import 'package:equatable/equatable.dart';
import '../models/download/download_manifest.dart';
import '../models/download/download_status.dart';

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

  const DownloadManifestLoaded({
    required this.manifest,
    required this.downloadedChunks,
  });

  bool get isQuranFullyDownloaded =>
      downloadedChunks.length >= manifest.quran.chunks.length;

  @override
  List<Object?> get props => [manifest, downloadedChunks];
}

class DownloadProgressState extends DownloadState {
  final DownloadProgress progress;
  final int currentChunk;
  final int totalChunks;

  const DownloadProgressState({
    required this.progress,
    required this.currentChunk,
    required this.totalChunks,
  });

  @override
  List<Object?> get props => [progress, currentChunk, totalChunks];
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
