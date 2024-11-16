part of 'websocket.bloc.dart';

sealed class WebSocketState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WsConnecting extends WebSocketState {}

class WsConnected extends WebSocketState {
  final List<CameraInfo> listCameras;

  WsConnected({required this.listCameras});

  WsConnected copyWith({List<CameraInfo>? connectedCameras}) {
    return WsConnected(listCameras: connectedCameras ?? listCameras);
  }

  @override
  List<Object?> get props => [listCameras];
}

class WsNotConnected extends WebSocketState {}

class WsReconnecting extends WebSocketState {}
