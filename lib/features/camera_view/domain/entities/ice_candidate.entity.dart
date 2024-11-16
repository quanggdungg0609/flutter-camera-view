import 'package:equatable/equatable.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class IceCandidate extends Equatable {
  final String to;
  final RTCIceCandidate iceCandidate;

  const IceCandidate({required this.to, required this.iceCandidate});

  @override
  List<Object?> get props => [to, iceCandidate];
}
