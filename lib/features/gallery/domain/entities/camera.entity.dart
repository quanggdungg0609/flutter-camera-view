import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:equatable/equatable.dart';

abstract class Camera extends Equatable with CustomDropdownListFilter {
  final String cameraName;
  final String cameraUuid;

  const Camera({required this.cameraName, required this.cameraUuid});

  @override
  List<Object?> get props => [cameraName, cameraUuid];

  @override
  bool filter(String query) {
    return cameraName.toLowerCase().contains(query.toLowerCase());
  }
}
