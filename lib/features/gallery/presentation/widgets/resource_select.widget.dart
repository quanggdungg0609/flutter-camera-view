import 'package:animated_custom_dropdown/custom_dropdown.dart';
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
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResourceSelectCubit, ResourceSelectState>(
      builder: (resourceSelectContext, state) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: CustomDropdown<Camera>.search(
            hintText: "Veuillez sélectionner une resource...",
            excludeSelected: false,
            items: (state as StableState).listCameras,
            decoration: CustomDropdownDecoration(
              prefixIcon:
                  (state is LoadingDataState) ? const CircularProgressIndicator() : const Icon(Icons.camera_alt),
            ),
            listItemBuilder: (context, item, isSelected, onItemSelect) {
              return Text(item.cameraName);
            },
            headerBuilder: (context, selectedItem, enabled) {
              return Text(
                selectedItem.cameraName,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              );
            },
            onChanged: (camera) {
              BlocProvider.of<ResourceSelectCubit>(resourceSelectContext).setCurrentCameras(camera!);
            },
          ),
        );
      },
    );
  }
}
