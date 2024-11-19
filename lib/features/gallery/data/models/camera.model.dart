import 'package:flutter_camera_view/features/gallery/domain/entities/camera.entity.dart';

class CameraModel extends Camera {
  CameraModel({required super.cameraName, required super.cameraUuid});

  factory CameraModel.fromJson(Map<String, dynamic> json) {
    return CameraModel(cameraName: json["name"], cameraUuid: json["uuid"]);
  }
}
