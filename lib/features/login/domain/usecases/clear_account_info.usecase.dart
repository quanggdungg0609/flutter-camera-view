import 'package:dartz/dartz.dart';
import 'package:flutter_camera_view/core/failures/auth.failure.dart';
import 'package:flutter_camera_view/core/usecase.dart';
import 'package:flutter_camera_view/features/login/domain/repositories/auth.repository.dart';

class ClearAccountInfoUseCase implements UseCase<Unit, NoParams> {
  final AuthRepository repository;

  ClearAccountInfoUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams _) async {
    return await repository.clearAccountInfo();
  }
}
