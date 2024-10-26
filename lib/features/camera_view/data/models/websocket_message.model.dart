import 'package:flutter_camera_view/features/camera_view/data/models/camera_info.model.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/camera_info.entity.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/websocket_message.entity.dart';

class CameraConnectMessageModel extends CameraConnectMessage {
  const CameraConnectMessageModel({required super.event, required super.cameraInfo});

  factory CameraConnectMessageModel.fromJson(Map<String, dynamic> json) {
    final cameraInfo = CameraInfoModel.fromJson(json["data"]);
    return CameraConnectMessageModel(event: json["event"], cameraInfo: cameraInfo);
  }
}

class CameraDisconnectMessageModel extends CameraDisconnectMessage {
  const CameraDisconnectMessageModel({required super.event, required super.cameraInfo});

  factory CameraDisconnectMessageModel.fromJson(Map<String, dynamic> json) {
    final cameraInfo = CameraInfoModel.fromJson(json["data"]);
    return CameraDisconnectMessageModel(event: json["event"], cameraInfo: cameraInfo);
  }
}
