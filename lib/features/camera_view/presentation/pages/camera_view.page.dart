import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/bloc/camera_select_cubit/camera_select.cubit.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/bloc/webrtc_bloc/webrtc.bloc.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/bloc/websocket_bloc/websocket.bloc.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/widgets/cameras_section.widget.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/widgets/live_video_section.widget.dart';
import 'package:flutter_camera_view/injection_container.dart';

class CameraViewPage extends StatefulWidget {
  const CameraViewPage({super.key});

  @override
  State<CameraViewPage> createState() => _CameraViewPageState();
}

class _CameraViewPageState extends State<CameraViewPage> with WidgetsBindingObserver {
  AppLifecycleState _state = AppLifecycleState.resumed;
  BuildContext? _loadingDialogContext;
  bool _isRequest = false;

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
    } else if (_state == AppLifecycleState.resumed) {}
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
          BlocProvider<WebRTCBloc>(
            create: (_) => sl<WebRTCBloc>(),
          ),
          BlocProvider<CameraSelectCubit>(
            create: (_) => sl<CameraSelectCubit>(),
          ),
        ],
        child: SafeArea(
          child: LayoutBuilder(
            builder: (layoutBuilderContext, constraints) {
              final scaffoldHeight = constraints.maxHeight;
              return BlocListener<WebSocketBloc, WebSocketState>(
                listener: (wsListenerContext, state) {
                  if (state is WsConnecting) {
                    if (_loadingDialogContext == null) {
                      showDialog(
                        context: wsListenerContext,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          _loadingDialogContext = context;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
                    }
                  } else {
                    if (_loadingDialogContext != null) {
                      Navigator.of(_loadingDialogContext!, rootNavigator: true).pop();
                      _loadingDialogContext = null;
                    }
                  }

                  if (state is WsConnected) {
                    print(state);
                    if (!_isRequest) {
                      BlocProvider.of<WebSocketBloc>(wsListenerContext).add(
                        const WsSendMessageEvent(
                          message: {
                            "event": "request-list-camera",
                          },
                        ),
                      );
                      setState(
                        () {
                          _isRequest = true;
                        },
                      );
                    }
                    BlocProvider.of<CameraSelectCubit>(layoutBuilderContext).setCameras(state.listCameras);
                  }
                },
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: scaffoldHeight / 3,
                      child: const LiveVideoSection(),
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
