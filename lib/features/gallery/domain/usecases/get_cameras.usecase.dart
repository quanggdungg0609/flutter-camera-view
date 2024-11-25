import 'package:dartz/dartz.dart';
import 'package:flutter_camera_view/core/failures/failure.dart';
import 'package:flutter_camera_view/core/usecase.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/camera.entity.dart';
import 'package:flutter_camera_view/features/gallery/domain/repositories/gallerie.repository.dart';

class GetCamerasUseCase extends UseCase<List<Camera>, NoParams> {
  final GallerieRepository repository;

  GetCamerasUseCase({required this.repository});

  @override
  Future<Either<Failure, List<Camera>>> call(NoParams params) async {
    return await repository.getListCameras();
  }
}
