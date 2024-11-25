import 'package:flutter_camera_view/features/gallery/domain/entities/media_item.entity.dart';

class MediaItemModel extends MediaItem {
  const MediaItemModel({
    required super.mediaName,
    required super.mediaUrl,
    required super.size,
    required super.lastModified,
    super.videoThumbnail,
  });
}
