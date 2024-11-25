import 'package:dartz/dartz.dart';
import 'package:flutter_camera_view/core/failures/failure.dart';
import 'package:flutter_camera_view/core/failures/gallerie.failure.dart';
import 'package:flutter_camera_view/features/gallery/data/datasources/gallerie.datasource.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/camera.entity.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/media_info.entity.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/media_item.entity.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/media_page.entity.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/media_url.entity.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/video_thumbnail.entity.dart';
import 'package:flutter_camera_view/features/gallery/domain/repositories/gallerie.repository.dart';

class GallerieImplRepository implements GallerieRepository {
  final GallerieDataSource gallerieDataSource;

  GallerieImplRepository({
    required this.gallerieDataSource,
  });

  @override
  Future<Either<Failure, List<Camera>>> getListCameras() async {
    try {
      final listCameras = await gallerieDataSource.getCameras();
      return Right(listCameras);
    } catch (e) {
      return Left(GetListCamerasFailure());
    }
  }

  @override
  Future<Either<Failure, List<MediaInfo>>> getMediaInfos(
    String cameraUuid,
    List<String> mediaNames,
    bool isVideo,
  ) async {
    try {
      final List<MediaInfo> mediaInfos =
          await gallerieDataSource.getMediaInfos(cameraUuid, mediaNames, isVideoInfos: isVideo);
      return Right(mediaInfos);
    } catch (e) {
      return Left(GetListMediaInfos(isVideo: isVideo));
    }
  }

  @override
  Future<Either<Failure, MediaPage>> getMediaPage(
    String cameraUuid, {
    int page = 1,
    int limit = 6,
    bool isGetVideos = false,
  }) async {
    try {
      final MediaPage mediaPage =
          await gallerieDataSource.getMediaPage(cameraUuid, page: page, limit: limit, isGetVideos: isGetVideos);

      return Right(mediaPage);
    } catch (e) {
      return Left(GetMediaPageFailure(isVideo: isGetVideos));
    }
  }

  @override
  Future<Either<Failure, List<MediaUrl>>> getMediaUrls(String cameraUuid, List<String> mediaNames, bool isVideo) async {
    try {
      final List<MediaUrl> listMediaUrls =
          await gallerieDataSource.getMediaUrls(cameraUuid, mediaNames, isVideoUrls: isVideo);
      return Right(listMediaUrls);
    } catch (e) {
      return Left(GetMediaUrlsFailure(isVideo: isVideo));
    }
  }

  @override
  Future<Either<Failure, List<VideoThumbnail>>> getVideoThumbnails(String cameraUuid, List<String> videoNames) async {
    try {
      final List<VideoThumbnail> videoThumbnails = await gallerieDataSource.getVideoThumbnails(cameraUuid, videoNames);
      return Right(videoThumbnails);
    } catch (e) {
      return Left(GetVideoThumbnailsFailure());
    }
  }

  @override
  Future<Either<Failure, List<MediaItem>>> getMediaItems(MediaPage mediaPage) async {
    try {
      final List<MediaItem> mediaItems = await gallerieDataSource.getMediaItems(mediaPage);
      return Right(mediaItems);
    } catch (e) {
      return Left(
        GetMediaItemsFailure(isVideo: mediaPage.isVideos),
      );
    }
  }
}
