import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/core/services/signaling.service.dart';
import 'package:flutter_camera_view/core/usecase.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/camera_info.entity.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/server_ws_message.entity.dart';
import 'package:flutter_camera_view/features/camera_view/domain/usescases/websocket_connect.usecase.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

part 'websocket.event.dart';
part 'websocket.state.dart';

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  final WebSocketConnectUseCase connectUseCase;
  final SignalingService signalingService;

  late Stream<ServerWsMessage> serverMessageStream;
  late Stream<RTCSessionDescription> sessionDescriptrionStream;

  WebSocketBloc({required this.connectUseCase, required this.signalingService}) : super(WsNotConnected()) {
    sessionDescriptrionStream = signalingService.sessionDescriptionStream;
    sessionDescriptrionStream.listen(
      (description) {
        if (description.type == "offer") {
          // send message later
        }
      },
    );

    on<WsConnectEvent>(
      (event, emit) async {
        emit(WsConnecting());
        final failureOrConnected = await connectUseCase.call(NoParams());

        failureOrConnected.fold(
          (failure) {
            emit(WsNotConnected());
          },
          (Stream<ServerWsMessage> messageStream) {
            serverMessageStream = messageStream;
            serverMessageStream.listen(
              (message) {
                _handleServerWsMessage(message);
              },
            );
            emit(WsConnected(listCameras: const []));
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
          var listCamera = (state as WsConnected).listCameras;
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
          var listCamera = (state as WsConnected).listCameras;
          listCamera.remove(event.camera);
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
          final sessionDescription = event.sessionDescription;
          signalingService.sendSessionDesciption(sessionDescription);
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
          WsCameraDisconnect(camera: cameraDisconnectMessage.cameraInfo),
        );
        break;
      default:
        if (kDebugMode) {
          print("Unknow message type");
        }
    }
  }
}
