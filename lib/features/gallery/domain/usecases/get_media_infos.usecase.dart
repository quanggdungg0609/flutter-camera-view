import 'package:dartz/dartz.dart';
import 'package:flutter_camera_view/core/failures/failure.dart';
import 'package:flutter_camera_view/core/usecase.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/media_info.entity.dart';
import 'package:flutter_camera_view/features/gallery/domain/repositories/gallerie.repository.dart';
import 'package:flutter_camera_view/features/gallery/domain/usecases/gallerie.param.dart';

class GetMediaInfosUseCase extends UseCase<List<MediaInfo>, GallerieParams> {
  final GallerieRepository repository;

  GetMediaInfosUseCase({required this.repository});

  @override
  Future<Either<Failure, List<MediaInfo>>> call(GallerieParams params) async {
    return repository.getMediaInfos(params.cameraUuid, params.mediaNames, params.isVideo);
  }
}
