part of 'websocket.bloc.dart';

sealed class WebSocketEvent extends Equatable {
  const WebSocketEvent();

  @override
  List<Object?> get props => [];
}

class WsConnectEvent extends WebSocketEvent {}

class WsDisconnectEvent extends WebSocketEvent {}

class WsSendMessageEvent extends WebSocketEvent {
  final Map<String, dynamic> message;

  const WsSendMessageEvent({required this.message});

  @override
  List<Object?> get props => [message];
}

class WsCameraConnectEvent extends WebSocketEvent {
  final CameraInfo camera;

  const WsCameraConnectEvent({required this.camera});

  @override
  List<Object?> get props => [camera];
}

class WsResponseListCameraEvent extends WebSocketEvent {
  final List<CameraInfo> listCamera;

  const WsResponseListCameraEvent({required this.listCamera});

  @override
  List<Object?> get props => [listCamera];
}

class WsCameraDisconnect extends WebSocketEvent {
  final String cameraUuid;

  const WsCameraDisconnect({required this.cameraUuid});

  @override
  List<Object?> get props => [cameraUuid];
}

class WsAnswerSDEvent extends WebSocketEvent {
  final RTCSessionDescription sessionDescription;

  const WsAnswerSDEvent({required this.sessionDescription});

  @override
  List<Object?> get props => [sessionDescription];
}

class WsReconnectingEvent extends WebSocketEvent {}
