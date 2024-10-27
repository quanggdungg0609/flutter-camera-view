import 'package:equatable/equatable.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

abstract class WsMessage extends Equatable {
  final String event;

  const WsMessage({required this.event});

  @override
  List<Object?> get props => [event];
}

abstract class RequestCameraListMessage extends WsMessage {
  const RequestCameraListMessage({required super.event});

  String toMessage() {
    return '{"event": "request-list-cameras"}';
  }
}

abstract class OfferSDMessage extends WsMessage {
  final RTCSessionDescription sessionDescription;
  const OfferSDMessage({required super.event, required this.sessionDescription});
}
