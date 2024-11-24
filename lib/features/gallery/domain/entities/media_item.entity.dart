import 'package:equatable/equatable.dart';

abstract class MediaItem extends Equatable {
  final String mediaName;
  final String mediaUrl;
  final int size;
  final String lastModified;
  final String? videoThumbnail;

  const MediaItem({
    required this.mediaName,
    required this.mediaUrl,
    required this.size,
    required this.lastModified,
    this.videoThumbnail,
  });

  @override
  List<Object?> get props => [
        mediaName,
        mediaUrl,
        size,
        lastModified,
        videoThumbnail,
      ];
}
