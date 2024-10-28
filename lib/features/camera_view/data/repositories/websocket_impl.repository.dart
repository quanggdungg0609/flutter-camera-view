import 'package:dartz/dartz.dart';
import 'package:flutter_camera_view/core/failures/failure.dart';
import 'package:flutter_camera_view/core/failures/websocket.failure.dart';
import 'package:flutter_camera_view/features/camera_view/data/datasources/websocket.datasource.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/server_ws_message.entity.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/ws_message.dart';
import 'package:flutter_camera_view/features/camera_view/domain/repositories/websocket.repository.dart';
import 'package:flutter_camera_view/features/login/data/datasources/local.datasource.dart';

class WebSocketImplRepository extends WebSocketRepository {
  final LocalDataSource localDataSource;
  final WebSocketDataSource wsDataSource;

  WebSocketImplRepository({required this.localDataSource, required this.wsDataSource});

  @override
  Future<Either<Failure, Stream<ServerWsMessage>>> connect() async {
    try {
      final uuid = await localDataSource.getUuid();
      if (uuid == null) {
        return Left(ConnectFailure());
      }
      final userInfo = await localDataSource.getUserInfo();
      if (userInfo == null) {
        return Left(ConnectFailure());
      }

      await wsDataSource.connect(userInfo.userName, uuid);

      return Right(wsDataSource.message);
    } catch (_) {
      return Left(ConnectFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> disconnect() {
    // TODO: implement disconnect
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> sendMessage(WsMessage message) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }
}
