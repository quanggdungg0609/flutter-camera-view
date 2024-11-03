import 'package:flutter_camera_view/features/camera_view/domain/entities/ice_candidate.entity.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class IceCandidateModel extends IceCandidate {
  const IceCandidateModel({
    required super.to,
    required super.iceCandidate,
  });

  factory IceCandidateModel.fromJson(Map<String, dynamic> json) {
    RTCIceCandidate iceCandidate = RTCIceCandidate(
      json["data"]["candidate"],
      json["data"]["sdpMid"],
      json["data"]["sdpMLineIndex"],
    );
    return IceCandidateModel(
      to: json["data"]["to"],
      iceCandidate: iceCandidate,
    );
  }
}
