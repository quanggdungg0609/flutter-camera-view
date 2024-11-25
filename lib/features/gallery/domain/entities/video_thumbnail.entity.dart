import 'package:equatable/equatable.dart';

abstract class VideoThumbnail extends Equatable {
  final String fileName;
  final String thumbnailLink;

  const VideoThumbnail({required this.fileName, required this.thumbnailLink});

  @override
  List<Object?> get props => [fileName, thumbnailLink];
}
