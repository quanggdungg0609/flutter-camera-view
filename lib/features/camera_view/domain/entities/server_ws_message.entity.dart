import 'package:equatable/equatable.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/camera_info.entity.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

abstract class ServerWsMessage extends Equatable {
  final String event;

  const ServerWsMessage({
    required this.event,
  });
  @override
  List<Object?> get props => [event];
}

abstract class CameraConnectMessage extends ServerWsMessage {
  final CameraInfo cameraInfo;
  const CameraConnectMessage({
    required this.cameraInfo,
  }) : super(event: 'camera-connect');

  @override
  List<Object?> get props => [event, cameraInfo];
}

abstract class CameraDisconnectMessage extends ServerWsMessage {
  final String cameraUuuid;

  const CameraDisconnectMessage({required this.cameraUuuid}) : super(event: "camera-disconnect");

  @override
  List<Object?> get props => [event, cameraUuuid];
}

abstract class ResponseCameraListMessage extends ServerWsMessage {
  final List<CameraInfo> cameras;

  const ResponseCameraListMessage({required this.cameras}) : super(event: "response-list-cameras");

  @override
  List<Object?> get props => [event, cameras];
}

abstract class PongMessage extends ServerWsMessage {
  const PongMessage() : super(event: "pong");

  @override
  List<Object?> get props => [event];
}

abstract class AnswerSDMessage extends ServerWsMessage {
  final RTCSessionDescription sessionDescription;
  const AnswerSDMessage({required this.sessionDescription}) : super(event: "answer-sd");

  @override
  List<Object?> get props => [event, sessionDescription];
}

abstract class IceCandidateMessage extends ServerWsMessage {
  final String from;
  final String to;
  final RTCIceCandidate iceCandidate;
  const IceCandidateMessage({required this.from, required this.to, required this.iceCandidate})
      : super(event: "ice-candidate");

  @override
  List<Object?> get props => [event, from, to, iceCandidate];
}
