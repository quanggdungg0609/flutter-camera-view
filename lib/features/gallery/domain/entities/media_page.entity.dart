import 'package:equatable/equatable.dart';

abstract class MediaPage extends Equatable {
  final int page;
  final int? nextPage;
  final int? prevPage;
  final int totalPage;
  final int totalItems;
  final List<String> fileNames;

  const MediaPage({
    required this.page,
    this.nextPage,
    this.prevPage,
    required this.totalPage,
    required this.totalItems,
    required this.fileNames,
  });

  @override
  List<Object?> get props => [
        page,
        nextPage,
        prevPage,
        totalPage,
        totalItems,
        fileNames,
      ];
}
