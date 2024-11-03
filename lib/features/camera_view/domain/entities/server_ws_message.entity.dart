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
    required super.event,
    required this.cameraInfo,
  });

  @override
  List<Object?> get props => [event, cameraInfo];
}

abstract class CameraDisconnectMessage extends ServerWsMessage {
  final CameraInfo cameraInfo;

  const CameraDisconnectMessage({required super.event, required this.cameraInfo});

  @override
  List<Object?> get props => [event, cameraInfo];
}

abstract class ResponseCameraListMessage extends ServerWsMessage {
  final List<CameraInfo> cameras;

  const ResponseCameraListMessage({required super.event, required this.cameras});

  @override
  List<Object?> get props => [event, cameras];
}

abstract class PongMessage extends ServerWsMessage {
  const PongMessage({required super.event});

  @override
  List<Object?> get props => [event];
}

abstract class AnswerSDMessage extends ServerWsMessage {
  final RTCSessionDescription sessionDescription;
  const AnswerSDMessage({required super.event, required this.sessionDescription});

  @override
  List<Object?> get props => [event, sessionDescription];
}

abstract class IceCandidateMessage extends ServerWsMessage {
  final String from;
  final String to;
  final RTCIceCandidate iceCandidate;
  const IceCandidateMessage({required super.event, required this.from, required this.to, required this.iceCandidate});

  @override
  List<Object?> get props => [event, from, to, iceCandidate];
}
