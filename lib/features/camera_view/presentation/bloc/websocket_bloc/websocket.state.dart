part of 'websocket.bloc.dart';

sealed class WebSocketState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WsConnecting extends WebSocketState {}

class WsConnected extends WebSocketState {}

class WsNotConnected extends WebSocketState {}
