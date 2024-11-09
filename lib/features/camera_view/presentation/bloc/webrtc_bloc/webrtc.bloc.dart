import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/core/constants/webrtc_configuration.dart';
import 'package:flutter_camera_view/core/services/signaling.service.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/ice_candidate.entity.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

part 'webrtc.event.dart';
part 'webrtc.state.dart';

class WebRTCBloc extends Bloc<WebRTCEvent, WebRTCState> {
  late RTCPeerConnection _peer;
  String currentCameraUUID = "";

  final SignalingService signalingService;

  late Stream<RTCSessionDescription> descriptionStream;
  late Stream<IceCandidate> iceCandidateRecvStream;
  late Stream<IceCandidate> iceCandidateSendStream;

  WebRTCBloc({required this.signalingService}) : super(WebRTCIntial()) {
    descriptionStream = signalingService.sessionDescriptionStream;
    iceCandidateRecvStream = signalingService.iceCandidateRecvStream;
    iceCandidateSendStream = signalingService.iceCandidateSendStream;

    on<SelectCurrentCameraEvent>(
      (event, emit) async {
        final currentState = state;
        if (state is WebRTCIntial) {
          currentCameraUUID = event.currentCameraUuid;
          // await _createPeer();
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

    Completer<void> iceCandidateCompleter = Completer();

    _peer.onIceCandidate = (candidate) async {
      // ignore: unnecessary_null_comparison
      if (candidate == null) {
        iceCandidateCompleter.complete();
        return;
      }
      final IceCandidate ice = IceCandidate(to: currentCameraUUID, iceCandidate: candidate);
      signalingService.addIceCandidateSend(ice);
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
    await iceCandidateCompleter.future;

    RTCSessionDescription sd = await _peer.createOffer(offerSdpConstraints);
    await _peer.setLocalDescription(sd);

    final offfer = await _peer.getLocalDescription();
  }

  @override
  Future<void> close() async {
    await descriptionStream.drain();
    await iceCandidateRecvStream.drain();
    await iceCandidateSendStream.drain();

    return super.close();
  }
}
