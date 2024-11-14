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

  StreamSubscription<AnswerSDMessage>? _answerStreamSubcriptionController;

  StreamSubscription<IceCandidate>? iceCandidateRecvStreamSubcriptionController;

  bool _isAnswerStreamSubscribed = false;

  WebRTCBloc({required this.signalingService, required this.getOwnUuidUseCase}) : super(WebRTCIntial()) {
    _initial();

    if (!_isAnswerStreamSubscribed) {
      _isAnswerStreamSubscribed = true;

      _answerStreamSubcriptionController = signalingService.answerStream.listen(
        (answer) async {
          if (_peer != null) {
            await _peer!.setRemoteDescription(answer.sessionDescription);
          }
        },
      );
      iceCandidateRecvStreamSubcriptionController = signalingService.iceCandidateRecvStream.listen((iceCandidate) {
        // todo:
      });
    }

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

    on<WebRTCConnectingEvent>(
      (event, emit) {
        emit(WebRTCConnecting());
      },
    );

    on<WebRTCConnectedEvent>(
      (event, emit) {
        emit(WebRTCConnected());
      },
    );

    on<WebRTCClosedEvent>(
      (event, emit) {
        emit(WebRTCClosed());
      },
    );

    on<WebRTCDisconnectedEvent>(
      (event, emit) {
        emit(WebRTCDisconnected());
      },
    );

    on<WebRTCFailedEvent>(
      (event, emit) {
        emit(WebRTCFailed());
      },
    );

    on<WebRTCNewEvent>(
      (event, emit) {
        emit(WebRTCNew());
      },
    );

    on<RemoteRendererReadyEvent>((event, emit) async {
      if (state is WebRTCConnected) {
        emit((state as WebRTCConnected).copyWith(event.stream));
      } else {
        emit(
          WebRTCConnected(stream: event.stream),
        );
      }
    });

    on<WebRTCDisconnectingEvent>(
      (event, emit) async {
        if (_peer != null && state is WebRTCConnected) {
          await _peer?.close();
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

    _peer!.onIceGatheringState = ((RTCIceGatheringState state) {
      if (state == RTCIceGatheringState.RTCIceGatheringStateComplete) {
        if (!iceGatheringCompleter.isCompleted) {
          iceGatheringCompleter.complete();
        }
      }
    });

    _peer!.onConnectionState = (RTCPeerConnectionState state) async {
      if (!isClosed) {
        if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnecting) {
          add(WebRTCConnectingEvent());
        }
        if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
          add(WebRTCConnectedEvent());
        }
        if (state == RTCPeerConnectionState.RTCPeerConnectionStateNew) {
          add(WebRTCNewEvent());
        }
        if (state == RTCPeerConnectionState.RTCPeerConnectionStateFailed) {
          add(WebRTCFailedEvent());
        }
        if (state == RTCPeerConnectionState.RTCPeerConnectionStateClosed) {
          add(WebRTCClosedEvent());
        }
        if (state == RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) {
          add(WebRTCDisconnectedEvent());
        }
      }
    };

    _peer!.onTrack = (RTCTrackEvent event) async {
      if (event.track.kind == "video") {
        add(
          RemoteRendererReadyEvent(
            stream: event.streams[0],
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
    _peer = null;
    _currentCameraUUID = "";
    _answerStreamSubcriptionController!.cancel();
    _answerStreamSubcriptionController = null;
    iceCandidateRecvStreamSubcriptionController!.cancel();
    iceCandidateRecvStreamSubcriptionController = null;

    _isAnswerStreamSubscribed = false; // Reset the subscription flag
    signalingService.dispose();
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
