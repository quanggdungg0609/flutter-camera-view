import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/bloc/webrtc_bloc/webrtc.bloc.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/bloc/websocket_bloc/websocket.bloc.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/widgets/list_cameras.widget.dart';
import 'package:flutter_camera_view/injection_container.dart';

class CameraViewPage extends StatelessWidget {
  const CameraViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MultiBlocProvider(
        providers: [
          BlocProvider<WebSocketBloc>(
            create: (_) => sl<WebSocketBloc>()
              ..add(
                WsConnectEvent(),
              ),
          ),
          BlocProvider<WebRTCBloc>(create: (_) => sl<WebRTCBloc>()),
        ],
        child: SafeArea(
          child: LayoutBuilder(
            builder: (layoutBuilderContext, constraints) {
              final scaffoldHeight = constraints.maxHeight;
              return Stack(
                children: [
                  // Container đầu tiên chiếm 1/3 chiều cao của Scaffold
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: scaffoldHeight / 3,
                    child: Container(
                      color: Colors.blue,
                    ),
                  ),
                  // Container thứ hai chiếm phần còn lại của Scaffold
                  Positioned(
                    top: scaffoldHeight / 3,
                    left: 0,
                    right: 0,
                    bottom: 0, // Để Container này không đè lên bottomNavigationBar
                    child: const ListCameras(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
