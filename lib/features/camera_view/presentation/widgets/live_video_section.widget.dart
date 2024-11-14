import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/bloc/camera_select_cubit/camera_select.cubit.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/bloc/webrtc_bloc/webrtc.bloc.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/widgets/camera_not_select.widget.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/widgets/live_video_card.widget.dart';

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
        padding: const EdgeInsets.all(18),
        child: BlocBuilder<CameraSelectCubit, CameraSelectState>(
          builder: (cameraSelectContext, cameraSelectState) {
            if (cameraSelectState.selectedCameraUuid == null) {
              return const CameraNotSelectWidget();
            }
            return const LiveVideoCardWidget();
          },
        ),
      ),
    );
  }
}
