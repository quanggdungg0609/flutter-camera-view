part of 'webrtc.bloc.dart';

sealed class WebRTCEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class WebRTCHaveLocalOfferEvent extends WebRTCEvent {
  final RTCSessionDescription sessionDescription;

  WebRTCHaveLocalOfferEvent({required this.sessionDescription});

  @override
  List<Object?> get props => [sessionDescription];
}
