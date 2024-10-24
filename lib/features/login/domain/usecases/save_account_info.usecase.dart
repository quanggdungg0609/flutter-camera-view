import 'package:dartz/dartz.dart';
import 'package:flutter_camera_view/core/failures/auth.failure.dart';
import 'package:flutter_camera_view/core/usecase.dart';
import 'package:flutter_camera_view/features/login/domain/repositories/auth.repository.dart';

class SaveAccountInfoParams {
  final String accountID;
  final String password;

  SaveAccountInfoParams(this.accountID, this.password);
}

class SaveAccountInfoUseCase implements UseCase<Unit, SaveAccountInfoParams> {
  final AuthRepository repository;

  SaveAccountInfoUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(SaveAccountInfoParams params) async {
    return await repository.saveAccountInfo(params.accountID, params.password);
  }
}
