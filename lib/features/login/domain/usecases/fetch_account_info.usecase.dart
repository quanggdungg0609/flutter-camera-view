import 'package:dartz/dartz.dart';
import 'package:flutter_camera_view/core/failures/failure.dart';
import 'package:flutter_camera_view/core/usecase.dart';
import 'package:flutter_camera_view/features/login/domain/entities/account_info.entity.dart';
import 'package:flutter_camera_view/features/login/domain/repositories/account_info.repository.dart';

class FetchAccountInfoUseCase implements UseCase<AccountInfo?, NoParams> {
  final AccountInfoRepository repository;

  FetchAccountInfoUseCase(this.repository);

  @override
  Future<Either<Failure, AccountInfo?>> call(NoParams _) async {
    return await repository.fetchAccountInfo();
  }
}
