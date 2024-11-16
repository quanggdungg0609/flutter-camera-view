import 'package:dartz/dartz.dart';
import 'package:flutter_camera_view/core/exceptions/local_datasource.exception.dart';
import 'package:flutter_camera_view/core/failures/failure.dart';
import 'package:flutter_camera_view/core/failures/local_resource.failure.dart';
import 'package:flutter_camera_view/features/camera_view/domain/repositories/local_resource.repository.dart';
import 'package:flutter_camera_view/features/login/data/datasources/local.datasource.dart';

class LocalResourceImplRepository implements LocalResourceRepository {
  final LocalDataSource localDataSource;

  LocalResourceImplRepository({required this.localDataSource});

  @override
  Future<Either<Failure, String>> getUuid() async {
    try {
      final uuid = await localDataSource.getUuid();
      if (uuid == null) {
        throw GetUuidException();
      }
      return Right(uuid);
    } catch (_) {
      return Left(GetUuidFailure());
    }
  }
}
