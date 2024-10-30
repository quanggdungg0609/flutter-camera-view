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
        return RequestCameraListMessage(event: map["event"]);
      case "offer-sd":
        return OfferSDMessage(
          event: map["event"],
          uuid: map["data"]["uuid"],
          sessionDescription: RTCSessionDescription(
            map["data"]["sdp"],
            map["data"]["type"],
          ),
          cameraTargetUuid: map["data"]["to"],
        );
      // TODO: implement ice candidate
      default:
        throw UnknowEventType();
    }
  }
}

class RequestCameraListMessage extends WsMessage {
  const RequestCameraListMessage({required super.event});

  @override
  String toMessage() {
    return jsonEncode({"event": "request-list-cameras"});
  }
}

class OfferSDMessage extends WsMessage {
  final String uuid;
  final RTCSessionDescription sessionDescription;
  final String cameraTargetUuid;
  const OfferSDMessage({
    required super.event,
    required this.uuid,
    required this.sessionDescription,
    required this.cameraTargetUuid,
  });

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
