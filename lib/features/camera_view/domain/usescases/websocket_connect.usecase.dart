import 'package:dartz/dartz.dart';
import 'package:flutter_camera_view/core/failures/failure.dart';
import 'package:flutter_camera_view/core/usecase.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/server_ws_message.entity.dart';
import 'package:flutter_camera_view/features/camera_view/domain/repositories/websocket.repository.dart';

class WebSocketConnectUseCase extends UseCase<Stream<ServerWsMessage>, NoParams> {
  final WebSocketRepository wsRepository;

  WebSocketConnectUseCase({required this.wsRepository});

  @override
  Future<Either<Failure, Stream<ServerWsMessage>>> call(NoParams params) async {
    return await wsRepository.connect();
  }
}
