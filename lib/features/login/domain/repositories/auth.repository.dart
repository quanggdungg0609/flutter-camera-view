import 'package:dartz/dartz.dart';
import 'package:flutter_camera_view/core/failures/auth.failure.dart';
import 'package:flutter_camera_view/features/login/domain/entities/user_info.entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserInfo>> login(String account, String password);
}
