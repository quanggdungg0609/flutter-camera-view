import 'package:flutter_camera_view/features/gallery/domain/entities/media_url.entity.dart';

class MediaUrlModel extends MediaUrl {
  const MediaUrlModel({
    required super.fileName,
    required super.fileUrl,
    required super.isVideo,
  });
}
