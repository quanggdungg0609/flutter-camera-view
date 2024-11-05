import 'dart:async';
import 'dart:convert';

import 'package:flutter_camera_view/core/exceptions/websocket_datasource.exception.dart';
import 'package:flutter_camera_view/features/camera_view/data/models/server_ws_message.model.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/server_ws_message.entity.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/ws_message.entity.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

abstract class WebSocketDataSource {
  Stream<ServerWsMessage> get message;
  Future<void> connect(String accountID, String uuid);
  Future<void> send(WsMessage message);
  Future<void> disconnect();
}

class WebSocketDataSourceImpl extends WebSocketDataSource {
  final StreamController<ServerWsMessage> _messageController = StreamController<ServerWsMessage>.broadcast();
  WebSocketChannel? wsChannel;

  @override
  Future<void> connect(String accountID, String uuid) async {
    try {
      if (wsChannel == null) {
        final wsUri = Uri.parse("${dotenv.env["WS_URI"]!}/ws/user/$accountID/$uuid/");
        final channel = WebSocketChannel.connect(wsUri);

        await channel.ready;

        wsChannel = channel;
        wsChannel!.stream.listen(
          (dynamic message) {
            final messageJson = jsonDecode(message);
            if (messageJson != null) {
              final mess = _jsonToMessage(messageJson);
              _messageController.add(mess!);
            }
          },
        );
      }
      return;
    } catch (e) {
      throw ConnectException();
    }
  }

  @override
  Future<void> disconnect() async {
    try {
      if (wsChannel != null) {
        await wsChannel!.sink.close(status.normalClosure);
        print("disconnected");
        wsChannel = null;
      }
      return;
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
        return IceCandidateMessageModel.fromJson(json);
      default:
        return null;
    }
  }
}
