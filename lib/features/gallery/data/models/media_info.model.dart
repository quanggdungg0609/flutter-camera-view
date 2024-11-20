import 'package:flutter_camera_view/features/gallery/domain/entities/media_info.entity.dart';

class MediaInfoModel extends MediaInfo {
  const MediaInfoModel({required super.name, required super.size, required super.lastModified, required super.isVideo});

  factory MediaInfoModel.fromJson(Map<String, dynamic> json, bool isVideo) {
    return MediaInfoModel(
      name: json["name"],
      size: json["size"],
      lastModified: json["last_modified"],
      isVideo: isVideo,
    );
  }
}
