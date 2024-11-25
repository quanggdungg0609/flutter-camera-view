import 'package:dartz/dartz.dart';
import 'package:flutter_camera_view/core/failures/failure.dart';
import 'package:flutter_camera_view/core/usecase.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/media_url.entity.dart';
import 'package:flutter_camera_view/features/gallery/domain/repositories/gallerie.repository.dart';
import 'package:flutter_camera_view/features/gallery/domain/usecases/gallerie.param.dart';

class GetMediaUrlsUseCase extends UseCase<List<MediaUrl>, GallerieParams> {
  final GallerieRepository repository;

  GetMediaUrlsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<MediaUrl>>> call(GallerieParams params) async {
    return await repository.getMediaUrls(params.cameraUuid, params.mediaNames, params.isVideo);
  }
}
