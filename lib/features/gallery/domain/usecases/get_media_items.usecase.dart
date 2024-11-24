import 'package:dartz/dartz.dart';
import 'package:flutter_camera_view/core/failures/failure.dart';
import 'package:flutter_camera_view/core/usecase.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/media_item.entity.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/media_page.entity.dart';
import 'package:flutter_camera_view/features/gallery/domain/repositories/gallerie.repository.dart';

class GetMediaItemsParams {
  final String cameraUuid;
  final MediaPage mediaPage;

  GetMediaItemsParams({required this.cameraUuid, required this.mediaPage});
}

class GetMediaItemsUseCase extends UseCase<List<MediaItem>, GetMediaItemsParams> {
  final GallerieRepository gallerieRepository;

  GetMediaItemsUseCase({required this.gallerieRepository});

  @override
  Future<Either<Failure, List<MediaItem>>> call(params) async {
    return await gallerieRepository.getMediaItems(params.cameraUuid, params.mediaPage);
  }
}
