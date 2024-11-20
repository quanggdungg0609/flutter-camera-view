import 'package:dartz/dartz.dart';
import 'package:flutter_camera_view/core/failures/failure.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/server_ws_message.entity.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/ws_message.entity.dart';

abstract class WebSocketRepository {
  Future<Either<Failure, Stream<ServerWsMessage>>> connect();
  Future<Either<Failure, Unit>> sendMessage(WsMessage message);
  Future<Either<Failure, Unit>> disconnect();
}
