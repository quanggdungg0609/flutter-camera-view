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

class SelectCurrentCameraEvent extends WebRTCEvent {
  final String currentCameraUuid;

  SelectCurrentCameraEvent({required this.currentCameraUuid});

  @override
  List<Object?> get props => [currentCameraUuid];
}

class WebRTCAnswerOfferEvent extends WebRTCEvent {
  final RTCSessionDescription sessionDescription;

  WebRTCAnswerOfferEvent({required this.sessionDescription});

  @override
  List<Object?> get props => [sessionDescription];
}

class RemoteRendererReadyEvent extends WebRTCEvent {
  final RTCVideoRenderer remoteRenderer;

  RemoteRendererReadyEvent({required this.remoteRenderer});

  @override
  List<Object?> get props => [remoteRenderer];
}
