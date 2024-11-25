import 'package:equatable/equatable.dart';

abstract class MediaUrl extends Equatable {
  final String fileName;
  final String fileUrl;
  final bool isVideo;

  const MediaUrl({required this.fileName, required this.fileUrl, required this.isVideo});

  @override
  List<Object?> get props => [fileName, fileUrl, isVideo];
}
