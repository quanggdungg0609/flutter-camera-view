import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/camera.entity.dart';
import 'package:flutter_camera_view/features/gallery/presentation/blocs/camera_select_cubit/resource_select.cubit.dart';

class ResourcesTabsWidget extends StatefulWidget {
  const ResourcesTabsWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ResourcesTabsWidgetState createState() => _ResourcesTabsWidgetState();
}

class _ResourcesTabsWidgetState extends State<ResourcesTabsWidget> {
  Camera? _currentCamera;

  //TODO:
  @override
  Widget build(BuildContext context) {
    print(_currentCamera);
    return BlocConsumer<ResourceSelectCubit, ResourceSelectState>(
      listener: (resourceSelectContext, state) {
        if (state is StableState) {
          print(state.currentCamera);
          if (state.currentCamera != null && _currentCamera == null) {
            setState(
              () {
                _currentCamera = state.currentCamera;
              },
            );
          }
          if (state.currentCamera != _currentCamera) {
            setState(
              () {
                _currentCamera = state.currentCamera;
              },
            );
          }
        }
      },
      builder: (resourceSelectCubit, state) {
        return Container();
      },
    );
  }
}
