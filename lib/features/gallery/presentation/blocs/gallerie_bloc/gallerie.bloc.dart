import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/media_item.entity.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/media_page.entity.dart';
import 'package:flutter_camera_view/features/gallery/domain/usecases/get_media_items.usecase.dart';
import 'package:flutter_camera_view/features/gallery/domain/usecases/get_media_page.usecase.dart';

part 'gallerie.event.dart';
part "gallerie.state.dart";

class GallerieBloc extends Bloc<GallerieEvent, GallerieState> {
  final GetMediaPageUseCase getMediaPageUseCase;
  final GetMediaItemsUseCase getMediaItemsUseCase;
  GallerieBloc({
    required this.getMediaPageUseCase,
    required this.getMediaItemsUseCase,
  }) : super(GallerieInitialState()) {
    on<GallerieFetchMediasEvent>(
      (event, emit) async {
        MediaPage? mediaPageResult;
        emit(GallerieFetchingState());
        final failureOrMediaPage = await getMediaPageUseCase.call(
          GetMediaPageParams(
            cameraUuid: event.cameraUuid,
            page: event.page,
            limit: event.limit,
            isVideo: event.isVideo,
          ),
        );

        failureOrMediaPage.fold(
          (failure) {
            //failure
            emit(GallerieFetchMediaFailedState());
          },
          (mediaPage) async {
            mediaPageResult = mediaPage;
          },
        );
        final failureOrMediaItems = await getMediaItemsUseCase
            .call(GetMediaItemsParams(cameraUuid: event.cameraUuid, mediaPage: mediaPageResult!));

        failureOrMediaItems.fold(
          (failure) {
            emit(GallerieFetchMediaFailedState());
          },
          (mediaItems) {
            emit(GallerieMediaFetchedState(
                cameraUuid: event.cameraUuid, mediaPage: mediaPageResult!, items: mediaItems));
          },
        );
      },
    );
  }
}
