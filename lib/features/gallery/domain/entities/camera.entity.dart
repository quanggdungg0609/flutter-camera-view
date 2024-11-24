import 'package:equatable/equatable.dart';

abstract class Camera extends Equatable {
  final String cameraName;
  final String cameraUuid;

  const Camera({required this.cameraName, required this.cameraUuid});

  @override
  List<Object?> get props => [cameraName, cameraUuid];
}
