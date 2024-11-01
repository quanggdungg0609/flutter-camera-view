part of "webrtc.bloc.dart";

sealed class WebRTCState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WebRTCIntial extends WebRTCState {}

class WebRTCNew extends WebRTCState {}

class WebRTCConnecting extends WebRTCState {}

class WebRTCConnected extends WebRTCState {
  final RTCVideoRenderer? remoteRender;

  WebRTCConnected({this.remoteRender});

  factory WebRTCConnected.copyWith(RTCVideoRenderer remote) {
    return WebRTCConnected(remoteRender: remote);
  }
}

class WebRTCClosed extends WebRTCState {}

class WebRTCConnectFailed extends WebRTCState {}
