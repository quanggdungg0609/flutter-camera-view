import 'package:dartz/dartz.dart';
import 'package:flutter_camera_view/core/failures/auth.failure.dart';
import 'package:flutter_camera_view/features/login/domain/entities/account_info.entity.dart';
import 'package:flutter_camera_view/features/login/domain/entities/user_info.entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, Unit>> login(String account, String password);

  Future<Either<Failure, Unit>> saveAccountInfo(String account, String password);

  Future<Either<Failure, Unit>> clearAccountInfo();

  Future<Either<Failure, AccountInfo?>> fetchAccountInfo();
}
