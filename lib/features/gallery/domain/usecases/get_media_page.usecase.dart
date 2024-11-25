import 'package:dartz/dartz.dart';
import 'package:flutter_camera_view/core/failures/failure.dart';
import 'package:flutter_camera_view/core/usecase.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/media_page.entity.dart';
import 'package:flutter_camera_view/features/gallery/domain/repositories/gallerie.repository.dart';

class GetMediaPageParams {
  final String cameraUuid;
  final int page;
  final int limit;
  final bool isVideo;

  GetMediaPageParams({required this.cameraUuid, this.page = 1, this.limit = 5, this.isVideo = false});
}

class GetMediaPageUseCase extends UseCase<MediaPage, GetMediaPageParams> {
  final GallerieRepository repository;

  GetMediaPageUseCase({required this.repository});

  @override
  Future<Either<Failure, MediaPage>> call(GetMediaPageParams params) async {
    return await repository.getMediaPage(
      params.cameraUuid,
      page: params.page,
      limit: params.limit,
      isGetVideos: params.isVideo,
    );
  }
}
