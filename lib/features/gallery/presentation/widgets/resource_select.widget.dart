import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/camera.entity.dart';
import 'package:flutter_camera_view/features/gallery/presentation/blocs/camera_select_cubit/resource_select.cubit.dart';

class ResourceSelectWidget extends StatefulWidget {
  const ResourceSelectWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ResourceSelectWidgetState createState() => _ResourceSelectWidgetState();
}

class _ResourceSelectWidgetState extends State<ResourceSelectWidget> {
  final _dropdownController = DropdownController<Camera>();
  @override
  void dispose() {
    _dropdownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResourceSelectCubit, ResourceSelectState>(
      builder: (resourceSelectContext, state) {
        return CoolDropdown<Camera>(
          dropdownList: (state as StableState)
              .listCameras
              .map(
                (item) => CoolDropdownItem<Camera>(label: item.cameraName, value: item),
              )
              .toList(),
          controller: _dropdownController,
          resultOptions: const ResultOptions(
            placeholder: "Veuillez choisir une resources...",
          ),
          dropdownItemOptions: const DropdownItemOptions(
            selectedTextStyle: TextStyle(
              color: Colors.blue,
            ),
          ),
          onChange: (Camera camera) {
            BlocProvider.of<ResourceSelectCubit>(resourceSelectContext).setCurrentCameras(camera);
            // _dropdownController.close();
          },
          dropdownTriangleOptions: const DropdownTriangleOptions(align: DropdownTriangleAlign.right),
        );
      },
    );
  }
}
