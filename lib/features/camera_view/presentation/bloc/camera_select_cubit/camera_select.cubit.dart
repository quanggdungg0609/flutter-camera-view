import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/core/usecase.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/camera_info.entity.dart';
import 'package:flutter_camera_view/features/camera_view/domain/usescases/get_own_uuid.usecase.dart';

part 'camera_select.state.dart';

class CameraSelectCubit extends Cubit<CameraSelectState> {
  final GetOwnUuidUseCase getOwnUuidUseCase;
  CameraSelectCubit({required this.getOwnUuidUseCase}) : super(const CameraSelectState());

  void setOwnUuid() async {
    final failureOrUuid = await getOwnUuidUseCase.call(NoParams());
    failureOrUuid.fold(
      (failure) {
        // ! failure can't get uuid
      },
      (uuid) {
        state.copyWith(uuid: uuid);
      },
    );
  }

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
