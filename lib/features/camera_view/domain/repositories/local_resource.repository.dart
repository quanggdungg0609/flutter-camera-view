import 'package:dartz/dartz.dart';
import 'package:flutter_camera_view/core/failures/failure.dart';

abstract class LocalResourceRepository {
  Future<Either<Failure, String>> getUuid();
}
