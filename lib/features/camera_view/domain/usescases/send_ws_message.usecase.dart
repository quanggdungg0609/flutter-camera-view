import 'package:dartz/dartz.dart';
import 'package:flutter_camera_view/core/failures/failure.dart';
import 'package:flutter_camera_view/core/usecase.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/ws_message.entity.dart';
import 'package:flutter_camera_view/features/camera_view/domain/repositories/websocket.repository.dart';

class SendMessageParams {
  final WsMessage message;

  SendMessageParams({required this.message});
}

class SendWsMessageUseCase extends UseCase<Unit, SendMessageParams> {
  final WebSocketRepository wsRepository;

  SendWsMessageUseCase({required this.wsRepository});

  @override
  Future<Either<Failure, Unit>> call(SendMessageParams params) async {
    return await wsRepository.sendMessage(params.message);
  }
}
