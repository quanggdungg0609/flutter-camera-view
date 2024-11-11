part of 'camera_select.cubit.dart';

class CameraSelectState extends Equatable {
  final List<CameraInfo> cameras;
  final String? selectedCameraUuid;

  const CameraSelectState({
    this.cameras = const [],
    this.selectedCameraUuid,
  });

  CameraSelectState copyWith({
    List<CameraInfo>? cameras,
    String? cameraSelectUuid,
  }) {
    return CameraSelectState(
      cameras: cameras ?? this.cameras,
      selectedCameraUuid: cameraSelectUuid ?? selectedCameraUuid,
    );
  }

  @override
  List<Object?> get props => [cameras, selectedCameraUuid];
}
