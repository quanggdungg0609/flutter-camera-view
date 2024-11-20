import 'package:equatable/equatable.dart';

abstract class MediaInfo extends Equatable {
  final String name;
  final int size;
  final String lastModified;
  final bool isVideo;

  const MediaInfo({
    required this.name,
    required this.size,
    required this.lastModified,
    required this.isVideo,
  });

  @override
  List<Object?> get props => [name, size, lastModified, isVideo];
}
