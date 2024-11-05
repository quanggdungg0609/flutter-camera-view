import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/bloc/webrtc_bloc/webrtc.bloc.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/bloc/websocket_bloc/websocket.bloc.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/widgets/cameras_section.widget.dart';
import 'package:flutter_camera_view/injection_container.dart';

class CameraViewPage extends StatefulWidget {
  const CameraViewPage({super.key});

  @override
  State<CameraViewPage> createState() => _CameraViewPageState();
}

class _CameraViewPageState extends State<CameraViewPage> with WidgetsBindingObserver {
  AppLifecycleState _state = AppLifecycleState.resumed;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    sl<WebSocketBloc>().close();
    sl<WebRTCBloc>().close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _state = state;
    });
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    if (_state == AppLifecycleState.paused) {
      sl<WebSocketBloc>().add(WsDisconnectEvent());
    } else if (_state == AppLifecycleState.resumed) {
      sl<WebSocketBloc>().add(WsConnectEvent());
    }
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
              return BlocListener<WebSocketBloc, WebSocketState>(
                listener: (context, state) {
                  if (state is WsConnecting) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                  } else {
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                },
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: scaffoldHeight / 3,
                      child: Container(
                        color: Colors.blue,
                      ),
                    ),
                    Positioned(
                      top: scaffoldHeight / 3,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: const CamerasSection(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
