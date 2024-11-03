import 'package:flutter_camera_view/features/camera_view/domain/entities/ice_candidate.entity.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:rxdart/subjects.dart';

class SignalingService {
  final _sessionDescriptionController = PublishSubject<RTCSessionDescription>();
  final _iceCandidateRecvController = PublishSubject<IceCandidate>();
  final _iceCandidateSendController = PublishSubject<IceCandidate>();

  Stream<RTCSessionDescription> get sessionDescriptionStream => _sessionDescriptionController.stream;
  Stream<IceCandidate> get iceCandidateRecvStream => _iceCandidateRecvController.stream;
  Stream<IceCandidate> get iceCandidateSendStream => _iceCandidateSendController.stream;

  void sendSessionDesciption(RTCSessionDescription description) {
    _sessionDescriptionController.add(description);
  }

  void addIceCandidateRecv(IceCandidate iceCandidate) {
    _iceCandidateRecvController.add(iceCandidate);
  }

  void addIceCandidateSend(IceCandidate iceCandidate) {
    _iceCandidateSendController.add(iceCandidate);
  }

  Future<void> dispose() async {
    await _sessionDescriptionController.close();
    await _iceCandidateRecvController.close();
  }
}
