import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/core/constants/webrtc_configuration.dart';
import 'package:flutter_camera_view/core/services/signaling.service.dart';
import 'package:flutter_camera_view/core/usecase.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/ice_candidate.entity.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/server_ws_message.entity.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/ws_message.entity.dart';
import 'package:flutter_camera_view/features/camera_view/domain/usescases/get_own_uuid.usecase.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

part 'webrtc.event.dart';
part 'webrtc.state.dart';

class WebRTCBloc extends Bloc<WebRTCEvent, WebRTCState> {
  final GetOwnUuidUseCase getOwnUuidUseCase;

  RTCPeerConnection? _peer;
  late String uuid;
  String _currentCameraUUID = "";

  final SignalingService signalingService;

  late Stream<AnswerSDMessage> _answerStream;

  late Stream<IceCandidate> iceCandidateRecvStream;
  late Stream<IceCandidate> iceCandidateSendStream;

  WebRTCBloc({required this.signalingService, required this.getOwnUuidUseCase}) : super(WebRTCIntial()) {
    _initial();
    _answerStream = signalingService.answerStream;
    iceCandidateRecvStream = signalingService.iceCandidateRecvStream;
    iceCandidateSendStream = signalingService.iceCandidateSendStream;

    on<SelectCurrentCameraEvent>(
      (event, emit) async {
        final currentState = state;
        if (state is WebRTCIntial) {
          _currentCameraUUID = event.currentCameraUuid;
          await _createPeer();
        } else if (currentState is WebRTCConnected) {
          _currentCameraUUID = event.currentCameraUuid;
        }
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
    final Completer<void> iceGatheringCompleter = Completer<void>();

    _peer!.onIceCandidate = (candidate) async {
      final IceCandidate ice = IceCandidate(to: _currentCameraUUID, iceCandidate: candidate);
      signalingService.addIceCandidateSend(ice);
    };

    _peer!.onIceGatheringState = ((state) {
      if (state == RTCIceGatheringState.RTCIceGatheringStateComplete) {
        if (!iceGatheringCompleter.isCompleted) {
          iceGatheringCompleter.complete();
        }
      }
    });

    _peer!.onTrack = (RTCTrackEvent event) async {
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
    // await iceCandidateCompleter.future;

    RTCSessionDescription sd = await _peer!.createOffer(offerSdpConstraints);
    await _peer!.setLocalDescription(sd);

    // Delayed timeout, if timeout use all created candidates
    Future.delayed(const Duration(seconds: 3), () {
      if (!iceGatheringCompleter.isCompleted) {
        iceGatheringCompleter.complete();
      }
    });

    await iceGatheringCompleter.future;

    final offer = await _peer!.getLocalDescription();

    final OfferSDMessage offerMessage = OfferSDMessage(
      event: "offer-sd",
      uuid: uuid,
      sessionDescription: offer!,
      cameraTargetUuid: _currentCameraUUID,
    );

    signalingService.sendOffer(offerMessage);
  }

  @override
  Future<void> close() async {
    await _answerStream.drain();

    await iceCandidateRecvStream.drain();
    await iceCandidateSendStream.drain();

    return super.close();
  }

  Future<void> _initial() async {
    final failureOrUuid = await getOwnUuidUseCase.call(NoParams());

    failureOrUuid.fold((failure) {
      // ! maybe disconnect because dont have uuid
    }, (uuid) {
      this.uuid = uuid;
    });
  }
}
