import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

abstract class WsMessage extends Equatable {
  final String event;

  const WsMessage({required this.event});

  String toMessage();

  @override
  List<Object?> get props => [event];
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
