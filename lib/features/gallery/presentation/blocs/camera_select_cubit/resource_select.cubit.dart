import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/core/usecase.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/camera.entity.dart';
import 'package:flutter_camera_view/features/gallery/domain/usecases/get_cameras.usecase.dart';

part 'resource_select.state.dart';

class ResourceSelectCubit extends Cubit<ResourceSelectState> {
  final GetCamerasUseCase getCamerasUseCase;
  ResourceSelectCubit({required this.getCamerasUseCase})
      : super(
          StableState(
            listCameras: [],
          ),
        );

  void getListCameras() async {
    final failureOrListCameras = await getCamerasUseCase.call(NoParams());
    emit(LoadingDataState());
    failureOrListCameras.fold((failure) {
      emit(LoadedDataFailedState());
    }, (listCameras) {
      emit(StableState(listCameras: listCameras));
    });
  }

  void setCurrentCameras(Camera camera) {
    if (state is StableState) {
      emit(
        (state as StableState).copyWith(currentCamera: camera),
      );
    }
  }
}
