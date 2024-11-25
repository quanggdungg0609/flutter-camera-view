import 'package:equatable/equatable.dart';

abstract class CameraInfo extends Equatable {
  final String uuid;
  final String name;
  final String location;

  const CameraInfo({required this.uuid, required this.name, required this.location});

  @override
  List<Object?> get props => [uuid, name, location];
}
