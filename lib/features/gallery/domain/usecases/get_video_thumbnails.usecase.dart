import 'package:dartz/dartz.dart';
import 'package:flutter_camera_view/core/failures/failure.dart';
import 'package:flutter_camera_view/core/usecase.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/video_thumbnail.entity.dart';
import 'package:flutter_camera_view/features/gallery/domain/repositories/gallerie.repository.dart';

class GetVideoThumbsParams {
  final String cameraUuid;
  final List<String> videoNames;

  GetVideoThumbsParams({required this.cameraUuid, required this.videoNames});
}

class GetVideoThumbnailsUseCase extends UseCase<List<VideoThumbnail>, GetVideoThumbsParams> {
  final GallerieRepository repository;

  GetVideoThumbnailsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<VideoThumbnail>>> call(GetVideoThumbsParams params) async {
    return await repository.getVideoThumbnails(params.cameraUuid, params.videoNames);
  }
}
