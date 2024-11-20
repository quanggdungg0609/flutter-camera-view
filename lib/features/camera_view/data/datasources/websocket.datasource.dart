import 'dart:async';
import 'dart:convert';

import 'package:flutter_camera_view/core/exceptions/websocket_datasource.exception.dart';
import 'package:flutter_camera_view/features/camera_view/data/models/server_ws_message.model.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/server_ws_message.entity.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/ws_message.entity.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/subjects.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status_ws;

abstract class WebSocketDataSource {
  Stream<WebSocketStatus> get status;
  Stream<ServerWsMessage> get message;
  Future<void> connect(String accountID, String uuid);
  Future<void> send(WsMessage message);
  Future<void> disconnect();
  Future<void> reconnect();
}

enum WebSocketStatus { connected, disconnected, connecting, error }

class WebSocketDataSourceImpl extends WebSocketDataSource {
  final StreamController<ServerWsMessage> _messageController = StreamController<ServerWsMessage>.broadcast();
  final BehaviorSubject<WebSocketStatus> _statusController =
      BehaviorSubject<WebSocketStatus>.seeded(WebSocketStatus.disconnected);
  String? _accountID;
  String? _uuid;

  WebSocketChannel? _wsChannel;

  @override
  Future<void> connect(String accountID, String uuid) async {
    try {
      if (_wsChannel == null) {
        final wsUri = Uri.parse("${dotenv.env["WS_URI"]!}/ws/user/$accountID/$uuid/");
        final channel = WebSocketChannel.connect(wsUri);

        await channel.ready;
        _wsChannel = channel;
        _wsChannel!.stream.listen(
          (dynamic message) {
            final messageJson = jsonDecode(message);
            if (messageJson != null) {
              final mess = _jsonToMessage(messageJson);
              _messageController.add(mess!);
            }
          },
          onDone: () {},
          onError: (error) {},
        );
        _accountID = accountID;
        _uuid = uuid;
      }
      return;
    } catch (e) {
      throw ConnectException();
    }
  }

  @override
  Future<void> disconnect() async {
    try {
      if (_wsChannel != null) {
        await _wsChannel!.sink.close(status_ws.normalClosure);
        _wsChannel = null;
      }
      return;
    } catch (_) {
      throw DisconnectException();
    }
  }

  @override
  Stream<ServerWsMessage> get message => _messageController.stream;

  @override
  Stream<WebSocketStatus> get status => _statusController.stream;

  WebSocketStatus get connectionStatus => _statusController.value;

  @override
  Future<void> send(WsMessage message) async {
    try {
      if (_wsChannel != null) {
        _wsChannel!.sink.add(message.toMessage());
      }
    } catch (_) {}
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
        return const PongMessageModel();
      case "ice-candidate":
        return IceCandidateMessageModel.fromJson(json);
      default:
        return null;
    }
  }

  @override
  Future<void> reconnect() async {
    try {
      if (_accountID == null || _uuid == null) {
        throw ReconnectException();
      }

      if (_wsChannel == null) {
        throw ReconnectException();
      }

      await connect(_accountID!, _uuid!);
    } catch (_) {}
  }
}
