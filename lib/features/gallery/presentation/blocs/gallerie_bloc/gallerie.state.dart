part of 'gallerie.bloc.dart';

abstract class GallerieState extends Equatable {}

class GallerieInitialState extends GallerieState {
  @override
  List<Object?> get props => [];
}

class GallerieFetchingState extends GallerieState {
  @override
  List<Object?> get props => [];
}

class GallerieMediaFetchedState extends GallerieState {
  final String cameraUuid;
  final MediaPage mediaPage;
  final List<MediaItem> items;

  GallerieMediaFetchedState({required this.cameraUuid, required this.mediaPage, required this.items});

  @override
  List<Object?> get props => [mediaPage, items, cameraUuid];
}

class GallerieFetchMediaFailedState extends GallerieState {
  @override
  List<Object?> get props => [];
}
