import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/bloc/camera_select_cubit/camera_select.cubit.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/bloc/webrtc_bloc/webrtc.bloc.dart';

class LiveVideoSection extends StatefulWidget {
  const LiveVideoSection({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LiveVideoWidgetState createState() => _LiveVideoWidgetState();
}

class _LiveVideoWidgetState extends State<LiveVideoSection> {
  String _currentCameraUUID = "";
  @override
  Widget build(BuildContext context) {
    return BlocListener<CameraSelectCubit, CameraSelectState>(
      listener: (cameraSelectContext, cameraSelectState) {
        if (cameraSelectState.selectedCameraUuid != null &&
            _currentCameraUUID != cameraSelectState.selectedCameraUuid) {
          setState(() {
            _currentCameraUUID = cameraSelectState.selectedCameraUuid!;
          });

          BlocProvider.of<WebRTCBloc>(cameraSelectContext).add(
            SelectCurrentCameraEvent(currentCameraUuid: cameraSelectState.selectedCameraUuid!),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Card(),
      ),
    );
  }
}
