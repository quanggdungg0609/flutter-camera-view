import 'package:flutter_camera_view/features/camera_view/domain/entities/ice_candidate.entity.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/server_ws_message.entity.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/ws_message.entity.dart';
import 'package:rxdart/subjects.dart';

class SignalingService {
  PublishSubject<OfferSDMessage> _offerDescriptionController = PublishSubject<OfferSDMessage>();
  PublishSubject<AnswerSDMessage> _answerDescriptionController = PublishSubject<AnswerSDMessage>();

  PublishSubject<IceCandidate> _iceCandidateRecvController = PublishSubject<IceCandidate>();
  PublishSubject<IceCandidate> _iceCandidateSendController = PublishSubject<IceCandidate>();

  Stream<OfferSDMessage> get offerStream => _offerDescriptionController.stream;
  Stream<AnswerSDMessage> get answerStream => _answerDescriptionController.stream;

  Stream<IceCandidate> get iceCandidateRecvStream => _iceCandidateRecvController.stream;
  Stream<IceCandidate> get iceCandidateSendStream => _iceCandidateSendController.stream;

  void sendOffer(OfferSDMessage offer) {
    _offerDescriptionController.add(offer);
  }

  void sendAnswer(AnswerSDMessage answer) {
    _answerDescriptionController.add(answer);
  }

  void addIceCandidateRecv(IceCandidate iceCandidate) {
    _iceCandidateRecvController.add(iceCandidate);
  }

  void addIceCandidateSend(IceCandidate iceCandidate) {
    _iceCandidateSendController.add(iceCandidate);
  }

  Future<void> dispose() async {
    await _offerDescriptionController.close();
    await _answerDescriptionController.close();
    await _iceCandidateSendController.close();
    await _iceCandidateRecvController.close();

    // Reinitialize the controllers
    _offerDescriptionController = PublishSubject<OfferSDMessage>();
    _answerDescriptionController = PublishSubject<AnswerSDMessage>();
    _iceCandidateRecvController = PublishSubject<IceCandidate>();
    _iceCandidateSendController = PublishSubject<IceCandidate>();
  }
}
