part of 'websocket.bloc.dart';

sealed class WebSocketEvent extends Equatable {
  const WebSocketEvent();

  @override
  List<Object?> get props => [];
}

class WsConnectEvent extends WebSocketEvent {}
