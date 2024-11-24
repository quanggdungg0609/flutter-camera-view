import 'package:dio/dio.dart';
import 'package:flutter_camera_view/core/exceptions/gallerie_datasource.exception.dart';
import 'package:flutter_camera_view/features/gallery/data/models/camera.model.dart';
import 'package:flutter_camera_view/features/gallery/data/models/media_info.model.dart';
import 'package:flutter_camera_view/features/gallery/data/models/media_item.model.dart';
import 'package:flutter_camera_view/features/gallery/data/models/media_page.model.dart';
import 'package:flutter_camera_view/features/gallery/data/models/media_url.model.dart';
import 'package:flutter_camera_view/features/gallery/data/models/video_thumbnail.model.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/camera.entity.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/media_info.entity.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/media_item.entity.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/media_page.entity.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/media_url.entity.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/video_thumbnail.entity.dart';

abstract class GallerieDataSource {
  Future<List<Camera>> getCameras();

  Future<MediaPage> getMediaPage(String cameraUuid, {int page, int limit, bool isGetVideos});

  // get media  actions
  Future<List<MediaInfo>> getMediaInfos(String cameraUuid, List<String> mediaNames, {bool isVideoInfos});
  Future<List<MediaUrl>> getMediaUrls(String cameraUuid, List<String> mediaNames, {bool isVideoUrls});

  // get video thumbnais
  Future<List<VideoThumbnail>> getVideoThumbnails(String cameraUuid, List<String> videoNames);

  Future<List<MediaItem>> getMediaItems(String cameraUuid, MediaPage mediaPage);
}

class GallerieDataSourceImpl implements GallerieDataSource {
  final Dio dio;
  GallerieDataSourceImpl({required this.dio});

  @override
  Future<List<Camera>> getCameras() async {
    try {
      final response = await dio.get("/files/get-cameras");
      List<Camera> result = (response.data["cameras"] as List).map((cameraInfoRaw) {
        return CameraModel.fromJson(cameraInfoRaw);
      }).toList();
      return result;
    } catch (e) {
      throw GetCamerasException();
    }
  }

  @override
  Future<List<MediaInfo>> getMediaInfos(String cameraUuid, List<String> mediaNames, {bool isVideoInfos = false}) async {
    try {
      final queryParams = [
        'uuid=$cameraUuid',
        ...mediaNames.map((name) => isVideoInfos ? 'video_names=$name' : 'image_names=$name'),
      ].join('&');

      final response = await dio.get(
        "/files/get-image-infos?$queryParams",
      );
      final List<dynamic> data = response.data['image_infos'];
      return data.map((item) => MediaInfoModel.fromJson(item, isVideoInfos)).toList();
    } catch (_) {
      throw GetMediaInfosException(message: isVideoInfos ? "Failed to get video infos" : "failed to get image infos");
    }
  }

  @override
  Future<List<MediaUrl>> getMediaUrls(String cameraUuid, List<String> mediaNames, {bool isVideoUrls = false}) async {
    try {
      final queryParams = [
        'uuid=$cameraUuid',
        ...mediaNames.map((name) => isVideoUrls ? 'video_names=$name' : 'image_names=$name'),
      ].join('&');
      final response = await dio.get(
        "/files/get-multiple-images?$queryParams",
      );
      // final List<String> result = List<String>.from(response.data['preview_urls']);
      if (mediaNames.length != (response.data["preview_urls"] as List).length) {
        throw GetMediaUrlsException(
          message: isVideoUrls ? "Failed to get video urls" : "Failed to get image urls",
        );
      }
      final List<MediaUrl> result = List.generate(mediaNames.length, (index) {
        return MediaUrlModel(
          fileName: mediaNames[index],
          fileUrl: (response.data["preview_urls"] as List)[index],
          isVideo: isVideoUrls,
        );
      });
      return result;
    } catch (e) {
      print(e);
      throw GetMediaUrlsException(
        message: isVideoUrls ? "Failed to get video urls" : "Failed to get image urls",
      );
    }
  }

  @override
  Future<MediaPage> getMediaPage(String cameraUuid, {int page = 1, int limit = 6, bool isGetVideos = false}) async {
    try {
      final String fileType = isGetVideos ? "videos" : "images";
      final String url = "/files/get-$fileType?uuid=$cameraUuid&page=$page&limit=$limit";
      final response = await dio.get(url);
      final MediaPage result = MediaPageModel.fromJson(response.data, isGetVideos, cameraUuid);
      return result;
    } catch (_) {
      throw GetMediaPageException(message: isGetVideos ? "Failed to get videos" : "Failed to get images");
    }
  }

  @override
  Future<List<VideoThumbnail>> getVideoThumbnails(String cameraUuid, List<String> videoNames) async {
    try {
      final queryParams = [
        'uuid=$cameraUuid',
        ...videoNames.map((name) => 'video_names=$name'),
      ].join('&');
      final String url = "/files/get-list-thumbnails?$queryParams";

      final response = await dio.get(url);

      if (videoNames.length != (response.data["thumbnais"] as List).length) {
        throw GetVideoThumbnaisException();
      }
      List<VideoThumbnail> result = List.generate(
        videoNames.length,
        (index) => VideoThumbnailModel(
          fileName: videoNames[index],
          thumbnailLink: (response.data["thumbnais"] as List)[index],
        ),
      );
      return result;
    } catch (_) {
      throw GetVideoThumbnaisException();
    }
  }

  @override
  Future<List<MediaItemModel>> getMediaItems(String cameraUuid, MediaPage mediaPage) async {
    try {
      // extract file names
      final List<String> fileNames = mediaPage.fileNames;
      final mediaInfosFuture = getMediaInfos(cameraUuid, fileNames, isVideoInfos: mediaPage.isVideos);
      final mediaUrlsFuture = getMediaUrls(cameraUuid, fileNames, isVideoUrls: mediaPage.isVideos);

      final videoThumbnailsFuture =
          mediaPage.isVideos ? getVideoThumbnails(cameraUuid, fileNames) : Future.value(<VideoThumbnail>[]);

      final resultFuture = await Future.wait([
        mediaInfosFuture,
        mediaUrlsFuture,
        videoThumbnailsFuture,
      ]);

      final mediaInfos = resultFuture[0] as List<MediaInfo>;
      final mediaUrls = resultFuture[1] as List<MediaUrl>;
      final videoThumbnails = resultFuture[2] as List<VideoThumbnail>;

      final mediaItems = <MediaItemModel>[];

      for (int i = 0; i < fileNames.length; i++) {
        final mediaInfo = mediaInfos.firstWhere(
          (info) => info.name == fileNames[i],
        );

        final mediaUrl = mediaUrls.firstWhere(
          (url) => url.fileName == fileNames[i],
        );

        final videoThumbnail = videoThumbnails.isNotEmpty
            ? videoThumbnails.firstWhere((thumbnail) => thumbnail.fileName == fileNames[i])
            : null;
        mediaItems.add(
          MediaItemModel(
            mediaName: mediaInfo.name,
            mediaUrl: mediaUrl.fileUrl,
            size: mediaInfo.size,
            lastModified: mediaInfo.lastModified,
            videoThumbnail: videoThumbnail?.thumbnailLink,
          ),
        );
      }
      return mediaItems;
    } catch (e) {
      rethrow;
    }
  }
}
