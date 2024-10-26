import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter_camera_view/features/camera_view/data/models/websocket_message.model.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/websocket_message.entity.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class WebSocketDataSource {
  Stream<String> get message;
  Future<void> connect(String accountID, String uuid);
  Future<void> send(String message);
  Future<void> disconnect();
}

class WebsocketDataSourceImpl extends WebSocketDataSource {
  late final StreamController<String> _messageController;
  late final WebSocketChannel wsChannel;

  @override
  Future<void> connect(String accountID, String uuid) async {
    try {
      final wsUri = Uri.parse("${dotenv.env["WS_URI"]!}/$accountID/$uuid/");
      final channel = WebSocketChannel.connect(wsUri);

      await channel.ready;

      wsChannel = channel;
      wsChannel.stream.listen((dynamic message) {
        final messageJson = jsonDecode(message);
        if (messageJson == null) {}
      });
    } catch (_) {}
  }

  @override
  Future<void> disconnect() {
    // TODO: implement disconnect
    throw UnimplementedError();
  }

  @override
  Stream<String> get message => _messageController.stream;

  @override
  Future<void> send(String message) {
    // TODO: implement send
    throw UnimplementedError();
  }

  WebsocketMessage? jsonToMessage(Map<String, dynamic> json) {
    switch (json["event"]) {
      case "camera-connect":
        return CameraConnectMessageModel.fromJson(json);
      case "camera-disconnect":
        return CameraDisconnectMessageModel.fromJson(json);
      default:
        return null;
    }
  }
}
