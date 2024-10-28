import 'dart:async';
import 'dart:convert';

import 'package:flutter_camera_view/core/exceptions/websocket_datasource.exception.dart';
import 'package:flutter_camera_view/features/camera_view/data/models/server_ws_message.model.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/server_ws_message.entity.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/ws_message.entity.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

abstract class WebSocketDataSource {
  Stream<ServerWsMessage> get message;
  Future<void> connect(String accountID, String uuid);
  Future<void> send(WsMessage message);
  Future<void> disconnect();
}

class WebSocketDataSourceImpl extends WebSocketDataSource {
  late final StreamController<ServerWsMessage> _messageController;
  late final WebSocketChannel wsChannel;

  @override
  Future<void> connect(String accountID, String uuid) async {
    try {
      final wsUri = Uri.parse("${dotenv.env["WS_URI"]!}/$accountID/$uuid/");
      final channel = WebSocketChannel.connect(wsUri);

      await channel.ready;

      _messageController = StreamController<ServerWsMessage>.broadcast();
      wsChannel = channel;
      wsChannel.stream.listen((dynamic message) {
        final messageJson = jsonDecode(message);
        if (messageJson != null) {
          final mess = _jsonToMessage(messageJson);
          _messageController.add(mess!);
        }
      });
    } catch (_) {
      throw ConnectException();
    }
  }

  @override
  Future<void> disconnect() async {
    try {
      await wsChannel.sink.close(status.goingAway);
    } catch (_) {
      throw DisconnectException();
    }
  }

  @override
  Stream<ServerWsMessage> get message => _messageController.stream;

  @override
  Future<void> send(WsMessage message) async {
    try {} catch (_) {}
  }

  ServerWsMessage? _jsonToMessage(Map<String, dynamic> json) {
    switch (json["event"]) {
      case "camera-connect":
        return CameraConnectMessageModel.fromJson(json);
      case "camera-disconnect":
        return CameraDisconnectMessageModel.fromJson(json);
      case "response-list-cameras":
        return ResponseCameraListMessageModel.fromJson(json);
      case "answer-sd":
        return AnswerSDMessageModel.fromJson(json);
      case "pong":
        return const PongMessageModel(event: "pong");
      case "ice-candidate":
        break;
      default:
        return null;
    }
  }
}
