import 'package:equatable/equatable.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/camera_info.entity.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

abstract class WebsocketMessage extends Equatable {
  final String event;

  const WebsocketMessage({
    required this.event,
  });
  @override
  List<Object?> get props => [event];
}

abstract class CameraConnectMessage extends WebsocketMessage {
  final CameraInfo cameraInfo;
  const CameraConnectMessage({
    required super.event,
    required this.cameraInfo,
  });

  @override
  List<Object?> get props => [event, cameraInfo];
}

abstract class ResponseCameraListMessage extends WebsocketMessage {
  final List<CameraInfo> cameras;

  const ResponseCameraListMessage({required super.event, required this.cameras});

  @override
  List<Object?> get props => [super.event, cameras];
}

abstract class PongMessage extends WebsocketMessage {
  const PongMessage({required super.event});

  @override
  List<Object?> get props => [super.event];
}

abstract class AnswerSDMessage extends WebsocketMessage {
  final RTCSessionDescription sessionDescription;
  const AnswerSDMessage({required super.event, required this.sessionDescription});

  @override
  List<Object?> get props => [super.event, sessionDescription];
}
