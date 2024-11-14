import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/camera_info.entity.dart';

part 'camera_select.state.dart';

class CameraSelectCubit extends Cubit<CameraSelectState> {
  CameraSelectCubit() : super(const CameraSelectState()) {}

  void setCameras(List<CameraInfo> cameras) {
    final updatedSelectedCameraUuid = cameras.isEmpty
        ? null
        : cameras.any((camera) => camera.uuid == state.selectedCameraUuid)
            ? state.selectedCameraUuid
            : null;
    emit(
      state.copyWith(
        cameras: cameras,
        cameraSelectUuid: updatedSelectedCameraUuid,
      ),
    );
  }

  void selectCamera(String cameraUuid) {
    if (state.selectedCameraUuid != cameraUuid) {
      emit(state.copyWith(cameraSelectUuid: cameraUuid));
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
