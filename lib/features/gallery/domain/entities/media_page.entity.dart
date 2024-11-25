import 'package:equatable/equatable.dart';

abstract class MediaPage extends Equatable {
  final String cameraUuid;
  final int page;
  final int? nextPage;
  final int? prevPage;
  final int totalPage;
  final int totalItems;
  final List<String> fileNames;
  final bool isVideos;

  const MediaPage({
    required this.cameraUuid,
    required this.page,
    this.nextPage,
    this.prevPage,
    required this.totalPage,
    required this.totalItems,
    required this.fileNames,
    this.isVideos = false,
  });

  @override
  List<Object?> get props => [
        cameraUuid,
        page,
        nextPage,
        prevPage,
        totalPage,
        totalItems,
        fileNames,
        isVideos,
      ];
}
