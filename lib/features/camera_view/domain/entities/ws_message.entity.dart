import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class UnknowEventType implements Exception {}

abstract class WsMessage extends Equatable {
  final String event;

  const WsMessage({required this.event});

  String toMessage();

  @override
  List<Object?> get props => [event];

  factory WsMessage.fromMap(Map<String, dynamic> map) {
    switch (map["event"]) {
      case "request-list-camera":
        return const RequestCameraListMessage();
      case "offer-sd":
        return OfferSDMessage(
          uuid: map["data"]["uuid"],
          sessionDescription: RTCSessionDescription(
            map["data"]["sdp"],
            map["data"]["type"],
          ),
          cameraTargetUuid: map["data"]["to"],
        );

      case "take-image":
        return TakeImageMessage(fromUuid: map["data"]["from"], toUuid: map["data"]["to"]);
      case "start-record":
        return StartRecordMessage(fromUuid: map["data"]["from"], toUuid: map["data"]["to"]);
      case "stop-record":
        return StopRecordMessage(fromUuid: map["data"]["from"], toUuid: map["data"]["to"]);
      case "ice-candidate":
      default:
        throw UnknowEventType();
    }
  }
}

class RequestCameraListMessage extends WsMessage {
  const RequestCameraListMessage() : super(event: "request-list-cameras");

  @override
  String toMessage() {
    return jsonEncode({"event": event});
  }
}

class OfferSDMessage extends WsMessage {
  final String uuid;
  final RTCSessionDescription sessionDescription;
  final String cameraTargetUuid;
  const OfferSDMessage({
    required this.uuid,
    required this.sessionDescription,
    required this.cameraTargetUuid,
  }) : super(event: "offer-sd");

  @override
  String toMessage() {
    return jsonEncode({
      "event": event,
      "data": {
        "uuid": uuid,
        "to": cameraTargetUuid,
        "type": sessionDescription.type,
        "sdp": sessionDescription.sdp,
      },
    });
  }

  @override
  List<Object?> get props => [
        event,
        sessionDescription,
        cameraTargetUuid,
      ];
}

class StartRecordMessage extends WsMessage {
  final String fromUuid;
  final String toUuid;

  const StartRecordMessage({
    required this.fromUuid,
    required this.toUuid,
  }) : super(event: "start-record");

  @override
  String toMessage() {
    return jsonEncode(
      {
        "event": event,
        "data": {
          "from": fromUuid,
          "to": toUuid,
        }
      },
    );
  }

  @override
  List<Object?> get props => [
        event,
        fromUuid,
        toUuid,
      ];
}

class StopRecordMessage extends WsMessage {
  final String fromUuid;
  final String toUuid;

  const StopRecordMessage({required this.fromUuid, required this.toUuid}) : super(event: "stop-record");

  @override
  String toMessage() {
    return jsonEncode(
      {
        "event": event,
        "data": {
          "from": fromUuid,
          "to": toUuid,
        }
      },
    );
  }

  @override
  List<Object?> get props => [
        event,
        fromUuid,
        toUuid,
      ];
}

class TakeImageMessage extends WsMessage {
  final String fromUuid;
  final String toUuid;

  const TakeImageMessage({required this.fromUuid, required this.toUuid}) : super(event: "take-image");

  @override
  String toMessage() {
    return jsonEncode(
      {
        "event": event,
        "data": {
          "from": fromUuid,
          "to": toUuid,
        }
      },
    );
  }

  @override
  List<Object?> get props => [event, toUuid, fromUuid];
}
