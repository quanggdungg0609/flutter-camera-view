part of 'camera_select.cubit.dart';

class CameraSelectState extends Equatable {
  final List<CameraInfo> cameras;
  final String? selectedCameraUuid;
  final String? uuid;

  const CameraSelectState({
    this.cameras = const [],
    this.selectedCameraUuid,
    this.uuid,
  });

  CameraSelectState copyWith({
    List<CameraInfo>? cameras,
    String? cameraSelectUuid,
    String? uuid,
  }) {
    return CameraSelectState(
      cameras: cameras ?? this.cameras,
      selectedCameraUuid: cameraSelectUuid ?? selectedCameraUuid,
      uuid: cameraSelectUuid ?? uuid,
    );
  }

  @override
  List<Object?> get props => [cameras, selectedCameraUuid];
}
