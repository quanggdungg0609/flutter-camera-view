import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/core/services/sdp_transport.service.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

part 'webrtc.event.dart';
part 'webrtc.state.dart';

class WebRTCBloc extends Bloc<WebRTCEvent, WebRTCState> {
  late RTCPeerConnection peer;
  late String currentCameraUUID;

  final SDPTransportService sdpTransportService;

  late Stream<RTCSessionDescription> descriptionStream;

  WebRTCBloc({required this.sdpTransportService}) : super(WebRTCIntial()) {
    descriptionStream = sdpTransportService.sessionDescriptionStream;
  }
}
