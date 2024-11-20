part of "resource_select.cubit.dart";

abstract class ResourceSelectState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StableState extends ResourceSelectState {
  final Camera? currentCamera;
  final List<Camera> listCameras;

  StableState({this.currentCamera, required this.listCameras});

  StableState copyWith({List<Camera>? listCameras, Camera? currentCamera}) {
    return StableState(
      currentCamera: currentCamera ?? this.currentCamera,
      listCameras: listCameras ?? this.listCameras,
    );
  }

  @override
  List<Object?> get props => [];
}

class LoadingDataState extends ResourceSelectState {}

class LoadedDataFailedState extends ResourceSelectState {}
