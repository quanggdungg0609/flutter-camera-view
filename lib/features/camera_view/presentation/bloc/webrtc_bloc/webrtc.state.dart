part of "webrtc.bloc.dart";

sealed class WebRTCState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WebRTCIntial extends WebRTCState {}

class WebRTCNew extends WebRTCState {}

class WebRTCConnecting extends WebRTCState {}

class WebRTCConnected extends WebRTCState {
  final MediaStream? stream;

  WebRTCConnected({this.stream});

  WebRTCConnected copyWith(MediaStream stream) {
    return WebRTCConnected(stream: stream);
  }

  @override
  List<Object?> get props => [stream];
}

class WebRTCClosed extends WebRTCState {}

class WebRTCFailed extends WebRTCState {}

class WebRTCDisconnected extends WebRTCState {}
