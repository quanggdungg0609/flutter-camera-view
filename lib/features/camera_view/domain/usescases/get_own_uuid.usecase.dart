import 'package:dartz/dartz.dart';
import 'package:flutter_camera_view/core/failures/failure.dart';
import 'package:flutter_camera_view/core/usecase.dart';
import 'package:flutter_camera_view/features/camera_view/domain/repositories/local_resource.repository.dart';

class GetOwnUuidUseCase extends UseCase<String, NoParams> {
  final LocalResourceRepository repository;

  GetOwnUuidUseCase({required this.repository});

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await repository.getUuid();
  }
}
