import 'package:flutter_camera_view/features/gallery/domain/entities/media_page.entity.dart';

class MediaPageModel extends MediaPage {
  const MediaPageModel({
    required super.page,
    super.nextPage,
    super.prevPage,
    required super.totalPage,
    required super.totalItems,
    required super.fileNames,
  });

  // Parse JSON into model
  factory MediaPageModel.fromJson(Map<String, dynamic> json) {
    return MediaPageModel(
      page: json['page'] as int,
      nextPage: json['nextPage'] as int?,
      prevPage: json['prevPage'] as int?,
      totalPage: json['totalPage'] as int,
      totalItems: json['totalItem'] as int, // Adjusted key
      fileNames: List<String>.from(json['files'] as List), // Adjusted key
    );
  }
}
