import 'package:flutter_camera_view/features/camera_view/domain/entities/camera_info.entity.dart';

class CameraInfoModel extends CameraInfo {
  const CameraInfoModel({required super.uuid, required super.name, required super.location});

  factory CameraInfoModel.fromJson(Map<String, dynamic> json) {
    return CameraInfoModel(
      uuid: json["uuid"],
      name: json["name"],
      location: json["location"],
    );
  }
}
