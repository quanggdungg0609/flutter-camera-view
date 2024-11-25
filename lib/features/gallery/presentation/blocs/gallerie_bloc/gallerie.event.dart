part of "gallerie.bloc.dart";

abstract class GallerieEvent extends Equatable {}

class GallerieFetchMediasEvent extends GallerieEvent {
  final String cameraUuid;
  final int page;
  final int limit;
  final bool isVideo;

  GallerieFetchMediasEvent({required this.cameraUuid, this.page = 1, this.limit = 6, this.isVideo = false});

  @override
  List<Object?> get props => [cameraUuid, page, limit, isVideo];
}
