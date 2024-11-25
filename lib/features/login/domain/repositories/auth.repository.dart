import 'package:dartz/dartz.dart';
import 'package:flutter_camera_view/core/failures/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, Unit>> login(String account, String password);
}
