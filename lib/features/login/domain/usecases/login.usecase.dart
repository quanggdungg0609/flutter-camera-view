import 'package:dartz/dartz.dart';
import 'package:flutter_camera_view/core/failures/auth.failure.dart';
import 'package:flutter_camera_view/core/usecase.dart';
import 'package:flutter_camera_view/features/login/domain/repositories/auth.repository.dart';

class LoginParams {
  final String accountID;
  final String password;
  LoginParams(this.accountID, this.password);
}

class LoginUseCase implements UseCase<Unit, LoginParams> {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  @override
  Future<Either<Failure, Unit>> call(LoginParams params) async {
    return await repository.login(params.accountID, params.password);
  }
}
