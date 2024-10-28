import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/core/usecase.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/server_ws_message.entity.dart';
import 'package:flutter_camera_view/features/camera_view/domain/usescases/websocket_connect.usecase.dart';

part 'websocket.event.dart';
part 'websocket.state.dart';

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  final WebSocketConnectUseCase connectUseCase;

  late Stream<ServerWsMessage> serverMessageStream;

  WebSocketBloc({required this.connectUseCase}) : super(WsNotConnected()) {
    on<WsConnectEvent>(
      (event, emit) async {
        emit(WsConnecting());
        final failureOrConnected = await connectUseCase.call(NoParams());

        failureOrConnected.fold((failure) {
          emit(WsNotConnected());
        }, (Stream<ServerWsMessage> messageStream) {
          serverMessageStream = messageStream;
          emit(WsConnected());
        });
      },
    );
  }
}
