import 'package:flutter_camera_view/features/camera_view/data/models/camera_info.model.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/camera_info.entity.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/server_ws_message.entity.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class CameraConnectMessageModel extends CameraConnectMessage {
  const CameraConnectMessageModel({required super.event, required super.cameraInfo});

  factory CameraConnectMessageModel.fromJson(Map<String, dynamic> json) {
    final cameraInfo = CameraInfoModel.fromJson(json["data"]);
    return CameraConnectMessageModel(event: json["event"], cameraInfo: cameraInfo);
  }
}

class CameraDisconnectMessageModel extends CameraDisconnectMessage {
  const CameraDisconnectMessageModel({required super.event, required super.cameraUuuid});

  factory CameraDisconnectMessageModel.fromJson(Map<String, dynamic> json) {
    return CameraDisconnectMessageModel(event: json["event"], cameraUuuid: json["data"]["uuid"]);
  }
}

class ResponseCameraListMessageModel extends ResponseCameraListMessage {
  const ResponseCameraListMessageModel({required super.event, required super.cameras});

  factory ResponseCameraListMessageModel.fromJson(Map<String, dynamic> json) {
    List<CameraInfo> cameras = [];
    for (final cameraJson in (json["data"] as List<dynamic>)) {
      cameras.add(CameraInfoModel.fromJson(cameraJson));
    }

    return ResponseCameraListMessageModel(event: json["event"], cameras: cameras);
  }
}

class PongMessageModel extends PongMessage {
  const PongMessageModel({required super.event});
}

class AnswerSDMessageModel extends AnswerSDMessage {
  const AnswerSDMessageModel({required super.event, required super.sessionDescription});

  factory AnswerSDMessageModel.fromJson(Map<String, dynamic> json) {
    RTCSessionDescription sd = RTCSessionDescription(
      json["data"]["sdp"],
      json["data"]["type"],
    );
    return AnswerSDMessageModel(event: json["event"], sessionDescription: sd);
  }
}

class IceCandidateMessageModel extends IceCandidateMessage {
  const IceCandidateMessageModel(
      {required super.event, required super.from, required super.to, required super.iceCandidate});

  factory IceCandidateMessageModel.fromJson(Map<String, dynamic> json) {
    RTCIceCandidate iceCandidate = RTCIceCandidate(
      json["data"]["candidate"],
      json["data"]["sdpMid"],
      json["data"]["sdpMLineIndex"],
    );
    return IceCandidateMessageModel(
      event: json["event"],
      from: json["data"]["from"],
      to: json["data"]["to"],
      iceCandidate: iceCandidate,
    );
  }
}
