import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/core/services/signaling.service.dart';
import 'package:flutter_camera_view/core/usecase.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/camera_info.entity.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/ice_candidate.entity.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/server_ws_message.entity.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/ws_message.entity.dart';
import 'package:flutter_camera_view/features/camera_view/domain/usescases/send_ws_message.usecase.dart';
import 'package:flutter_camera_view/features/camera_view/domain/usescases/websocket_connect.usecase.dart';
import 'package:flutter_camera_view/features/camera_view/domain/usescases/websocket_disconnect.usecase.dart';

part 'websocket.event.dart';
part 'websocket.state.dart';

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  final WebSocketConnectUseCase connectUseCase;
  final WebsocketDisconnectUseCase disconnectUseCase;
  final SendWsMessageUseCase sendWsMessageUseCase;

  StreamSubscription<ServerWsMessage>? _serverMessageStreamSubcriptionController;

  final SignalingService signalingService;
  late StreamSubscription<OfferSDMessage> _offerStreamSubcriptionController;

  late StreamSubscription<IceCandidate> _iceCandidateRecvStreamController;

  late StreamSubscription<IceCandidate> _iceCandidateSendStreamController;

  WebSocketBloc({
    required this.connectUseCase,
    required this.signalingService,
    required this.disconnectUseCase,
    required this.sendWsMessageUseCase,
  }) : super(WsNotConnected()) {
    _offerStreamSubcriptionController = signalingService.offerStream.listen(
      (offer) async {
        final failureOrSendMess = await sendWsMessageUseCase.call(SendMessageParams(message: offer));
        failureOrSendMess.fold((failure) {
          // todo: send noti
        }, (unit) {
          // todo: success
        });
      },
    );

    _iceCandidateSendStreamController = signalingService.iceCandidateSendStream.listen((iceCandidate) {
      // todo: setup to send iceCandidate from local peer to remote peer via webrtc
    });

    _iceCandidateRecvStreamController = signalingService.iceCandidateRecvStream.listen((iceCandidate) {
      // todo: setup to reiceive iceCandidate from remote peer to local peer
    });

    on<WsConnectEvent>(
      (event, emit) async {
        emit(WsConnecting());
        final failureOrConnected = await connectUseCase.call(NoParams());

        failureOrConnected.fold(
          (failure) {
            emit(WsNotConnected());
          },
          (Stream<ServerWsMessage> messageStream) {
            _serverMessageStreamSubcriptionController = messageStream.listen(
              (message) {
                _handleServerWsMessage(message);
              },
            );
            emit(WsConnected(listCameras: const []));
          },
        );
      },
    );

    on<WsDisconnectEvent>(
      (event, emit) async {
        final failureOrDisconnected = await disconnectUseCase.call(NoParams());

        failureOrDisconnected.fold(
          (failure) {
            // do nothing
          },
          (unit) {
            emit(WsNotConnected());
          },
        );
      },
    );

    on<WsSendMessageEvent>(
      (event, emit) async {
        WsMessage message = WsMessage.fromMap(event.message);
        final failureOrSendMess = await sendWsMessageUseCase.call(
          SendMessageParams(message: message),
        );

        failureOrSendMess.fold(
          (failure) {
            // failed but do nothing
          },
          (unit) {
            // success but do nothing
          },
        );
      },
    );

    on<WsResponseListCameraEvent>(
      (event, emit) async {
        var currentState = state;
        if (currentState is WsConnected) {
          emit(
            currentState.copyWith(connectedCameras: event.listCamera),
          );
        }
      },
    );

    on<WsCameraConnectEvent>(
      (event, emit) async {
        final currentState = state;
        if (state is WsConnected) {
          List<CameraInfo> listCamera = List.from((state as WsConnected).listCameras);
          listCamera.add(event.camera);
          emit(
            (currentState as WsConnected).copyWith(
              connectedCameras: listCamera,
            ),
          );
        }
      },
    );

    on<WsCameraDisconnect>(
      (event, emit) async {
        final currentState = state;
        if (state is WsConnected) {
          List<CameraInfo> listCamera = List.from((state as WsConnected).listCameras);
          listCamera.removeWhere((camera) => camera.uuid == event.cameraUuid);
          emit(
            (currentState as WsConnected).copyWith(
              connectedCameras: listCamera,
            ),
          );
        }
      },
    );

    on<WsAnswerSDEvent>(
      (event, emit) async {
        final currentState = state;
        if (currentState is WsConnected) {
          final answer = event.answer;

          signalingService.sendAnswer(answer);
        }
      },
    );
  }

  void _handleServerWsMessage(ServerWsMessage message) {
    switch (message) {
      case ResponseCameraListMessage responseCameraListMessage:
        add(
          WsResponseListCameraEvent(listCamera: responseCameraListMessage.cameras),
        );
        break;
      case CameraConnectMessage cameraConnectMessage:
        add(
          WsCameraConnectEvent(camera: cameraConnectMessage.cameraInfo),
        );
        break;
      case CameraDisconnectMessage cameraDisconnectMessage:
        add(
          WsCameraDisconnect(cameraUuid: cameraDisconnectMessage.cameraUuuid),
        );
        break;
      case AnswerSDMessage answerSDMessage:
        add(WsAnswerSDEvent(answer: answerSDMessage));
      default:
        if (kDebugMode) {
          print("Unknow message type");
        }
    }
  }

  @override
  Future<void> close() async {
    add(WsDisconnectEvent());
    if (_serverMessageStreamSubcriptionController != null) {
      _serverMessageStreamSubcriptionController!.cancel();
    }

    _offerStreamSubcriptionController.cancel();
    _iceCandidateRecvStreamController.cancel();
    _iceCandidateSendStreamController.cancel();

    return super.close();
  }
}
