import 'package:dartz/dartz.dart';
import 'package:flutter_camera_view/core/failures/auth.failure.dart';
import 'package:flutter_camera_view/core/usecase.dart';
import 'package:flutter_camera_view/features/login/domain/entities/account_info.entity.dart';
import 'package:flutter_camera_view/features/login/domain/repositories/auth.repository.dart';

class FetchAccountInfoUseCase implements UseCase<AccountInfo?, NoParams> {
  final AuthRepository repository;

  FetchAccountInfoUseCase(this.repository);

  @override
  Future<Either<Failure, AccountInfo?>> call(NoParams _) async {
    return await repository.fetchAccountInfo();
  }
}
