import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/features/gallery/presentation/blocs/camera_select_cubit/resource_select.cubit.dart';
import 'package:flutter_camera_view/features/gallery/presentation/widgets/no_resource_selected.widget.dart';
import 'package:flutter_camera_view/features/gallery/presentation/widgets/resources_tabs.widget.dart';

class MediaViewTabsWidget extends StatefulWidget {
  const MediaViewTabsWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MediaViewTabsWidgetState createState() => _MediaViewTabsWidgetState();
}

class _MediaViewTabsWidgetState extends State<MediaViewTabsWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: BlocBuilder<ResourceSelectCubit, ResourceSelectState>(
          builder: (resourceSelectContext, state) {
            if (state is StableState) {
              if (state.currentCamera == null) {
                return Center(
                  child: Container(
                      width: 300,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1, 1),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: const NoResourceSelectedWidget()),
                );
              } else {
                return ResourcesTabsWidget(
                  key: UniqueKey(),
                  currentCamera: state.currentCamera!,
                );
              }
            }
            return Container();
          },
        ),
      ),
    );
  }
}
