import 'package:dio/dio.dart';
import 'package:flutter_camera_view/core/exceptions/gallerie_datasource.exception.dart';
import 'package:flutter_camera_view/features/gallery/data/models/camera.model.dart';
import 'package:flutter_camera_view/features/gallery/data/models/image_info.model.dart';
import 'package:flutter_camera_view/features/gallery/data/models/media_page.model.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/camera.entity.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/media_info.entity.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/media_page.entity.dart';

abstract class GallerieDataSource {
  Future<List<Camera>> getCameras();

  Future<MediaPage> getMediaPage(String cameraUuid, {int page, int limit, bool isGetVideos});

  // get media  actions
  Future<List<MediaInfo>> getMediaInfos(String uuidCamera, List<String> mediaNames, {bool isVideoInfos});
  Future<List<String>> getMediaUrls(String uuidCamera, List<String> mediaNames, {bool isVideoUrls});

  // get video thumbnais
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
  Future<List<MediaInfo>> getMediaInfos(String uuidCamera, List<String> mediaNames, {bool isVideoInfos = false}) async {
    try {
      final queryParams = [
        'uuid=$uuidCamera',
        ...mediaNames.map((name) => isVideoInfos ? 'video_names=$name' : 'image_names=$name'),
      ].join('&');

      final response = await dio.get(
        "/files/get-image-infos?$queryParams",
      );
      final List<dynamic> data = response.data['image_infos'];
      return data.map((item) => MediaInfoModel.fromJson(item, isVideoInfos)).toList();
    } catch (_) {
      throw GetImagesInfosException();
    }
  }

  @override
  Future<List<String>> getMediaUrls(String uuidCamera, List<String> mediaNames, {bool isVideoUrls = false}) async {
    try {
      final queryParams = [
        'uuid=$uuidCamera',
        ...mediaNames.map((name) => isVideoUrls ? 'video_names=$name' : 'image_names=$name'),
      ].join('&');
      final response = await dio.get(
        "/files/get-multiple-images?$queryParams",
      );
      final List<String> result = List<String>.from(response.data['preview_urls']);
      return result;
    } catch (_) {
      throw GetImageUrlsException();
    }
  }

  @override
  Future<MediaPage> getMediaPage(String cameraUuid, {int page = 1, int limit = 6, bool isGetVideos = false}) async {
    try {
      final String fileType = isGetVideos ? "videos" : "images";
      final String url = "/files/get-$fileType?uuid=$cameraUuid&page=$page&limit=$limit";
      final response = await dio.get(url);
      final MediaPage result = MediaPageModel.fromJson(response.data);
      return result;
    } catch (_) {
      throw GetMediaPageException();
    }
  }
}
