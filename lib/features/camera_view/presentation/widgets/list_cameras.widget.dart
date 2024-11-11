import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/bloc/camera_select_cubit/camera_select.cubit.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/bloc/webrtc_bloc/webrtc.bloc.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/widgets/camera_card.widget.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/widgets/no_camera.widget.dart';

class ListCamerasWidget extends StatefulWidget {
  const ListCamerasWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ListCamerasWidgetState createState() => _ListCamerasWidgetState();
}

class _ListCamerasWidgetState extends State<ListCamerasWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraSelectCubit, CameraSelectState>(
      builder: (camerasContext, camerasState) {
        if (camerasState.cameras.isNotEmpty) {
          return BlocBuilder<WebRTCBloc, WebRTCState>(
            builder: (webRTCContext, webRTCstate) {
              return ListView.builder(
                itemCount: camerasState.cameras.length,
                itemBuilder: (listBuilderContext, index) {
                  if (camerasState.selectedCameraUuid == camerasState.cameras[index].uuid) {
                    return CameraCardWidget(
                      cameraInfo: camerasState.cameras[index],
                      isActive: false,
                    );
                  }
                  return CameraCardWidget(
                    cameraInfo: camerasState.cameras[index],
                  );
                },
              );
            },
          );
        }
        return const NoCameraWidget();
      },
    );
  }
}
