import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/core/constants/webrtc_configuration.dart';
import 'package:flutter_camera_view/core/services/sdp_transport.service.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

part 'webrtc.event.dart';
part 'webrtc.state.dart';

class WebRTCBloc extends Bloc<WebRTCEvent, WebRTCState> {
  late RTCPeerConnection _peer;
  late String currentCameraUUID;

  final SDPTransportService sdpTransportService;

  late Stream<RTCSessionDescription> descriptionStream;

  WebRTCBloc({required this.sdpTransportService}) : super(WebRTCIntial()) {
    descriptionStream = sdpTransportService.sessionDescriptionStream;

    on<SelectCurrentCameraEvent>(
      (event, emit) async {
        final currentState = state;
        if (state is WebRTCIntial) {
          await _createPeer();
        } else if (currentState is WebRTCConnected) {}
      },
    );
  }

  Future<void> _createPeer() async {
    _peer = await createPeerConnection(
      {
        ...iceServesConfig,
        ...{'sdpSemantics': sdpSemantics}
      },
    );

    _peer.onIceCandidate = (RTCIceCandidate candidate) {
      // TODO: implants later
    };

    _peer.onTrack = (RTCTrackEvent event) async {
      if (event.track.kind == "video") {
        RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
        await remoteRenderer.initialize();
        remoteRenderer.srcObject = event.streams[0];
        add(
          RemoteRendererReadyEvent(
            remoteRenderer: remoteRenderer,
          ),
        );
      }
    };

    RTCSessionDescription offer = await _peer.createOffer(offerSdpConstraints);
    await _peer.setLocalDescription(offer);
  }
}
