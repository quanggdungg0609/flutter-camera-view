part of "webrtc.bloc.dart";

sealed class WebRTCState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WebRTCIntial extends WebRTCState {}

class WebRTCNew extends WebRTCState {}

class WebRTCConnecting extends WebRTCState {}

class WebRTCConnected extends WebRTCState {}

class WebRTCCompleted extends WebRTCState {}

class WebRTCFailed extends WebRTCState {}

class WebRTCDisconnected extends WebRTCState {}

class WebRTCClosed extends WebRTCState {}
