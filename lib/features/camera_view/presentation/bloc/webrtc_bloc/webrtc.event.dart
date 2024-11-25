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
  final MediaStream stream;

  RemoteRendererReadyEvent({required this.stream});

  @override
  List<Object?> get props => [stream];
}

class WebRTCDisconnectingEvent extends WebRTCEvent {}

class WebRTCConnectingEvent extends WebRTCEvent {}

class WebRTCConnectedEvent extends WebRTCEvent {}

class WebRTCNewEvent extends WebRTCEvent {}

class WebRTCDisconnectedEvent extends WebRTCEvent {}

class WebRTCFailedEvent extends WebRTCEvent {}

class WebRTCClosedEvent extends WebRTCEvent {}
