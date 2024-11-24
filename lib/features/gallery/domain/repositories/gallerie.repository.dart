import 'package:dartz/dartz.dart';
import 'package:flutter_camera_view/core/failures/failure.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/camera.entity.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/media_info.entity.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/media_item.entity.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/media_page.entity.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/media_url.entity.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/video_thumbnail.entity.dart';

abstract class GallerieRepository {
  Future<Either<Failure, List<Camera>>> getListCameras();
  Future<Either<Failure, MediaPage>> getMediaPage(String cameraUuid, {int page, int limit, bool isGetVideos});
  Future<Either<Failure, List<MediaInfo>>> getMediaInfos(String cameraUuid, List<String> mediaNames, bool isVideo);
  Future<Either<Failure, List<MediaUrl>>> getMediaUrls(String cameraUuid, List<String> mediaNames, bool isVideo);
  Future<Either<Failure, List<VideoThumbnail>>> getVideoThumbnails(String cameraUuid, List<String> videoNames);
  Future<Either<Failure, List<MediaItem>>> getMediaItems(String cameraUuid, MediaPage mediaPage);
}
