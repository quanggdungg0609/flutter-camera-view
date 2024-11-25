import 'package:dartz/dartz.dart';
import 'package:flutter_camera_view/core/failures/failure.dart';
import 'package:flutter_camera_view/core/usecase.dart';
import 'package:flutter_camera_view/features/camera_view/domain/repositories/websocket.repository.dart';

class WebsocketDisconnectUseCase extends UseCase<Unit, NoParams> {
  final WebSocketRepository wsRepository;

  WebsocketDisconnectUseCase({required this.wsRepository});

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await wsRepository.disconnect();
  }
}
