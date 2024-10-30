import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:rxdart/subjects.dart';

class SDPTransportService {
  final _sessionDescriptionController = PublishSubject<RTCSessionDescription>();

  Stream<RTCSessionDescription> get sessionDescriptionStream => _sessionDescriptionController.stream;

  void sendSessionDesciption(RTCSessionDescription description) {
    _sessionDescriptionController.add(description);
  }

  void dispose() {
    _sessionDescriptionController.close();
  }
}
