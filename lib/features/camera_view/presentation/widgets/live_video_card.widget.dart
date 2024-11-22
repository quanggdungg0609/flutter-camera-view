import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/bloc/camera_select_cubit/camera_select.cubit.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/bloc/webrtc_bloc/webrtc.bloc.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/bloc/websocket_bloc/websocket.bloc.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/widgets/fullscreen_video_modal.widget.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/widgets/loading_stream.widget.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class LiveVideoCardWidget extends StatefulWidget {
  const LiveVideoCardWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LiveVideoCardWidgetState createState() => _LiveVideoCardWidgetState();
}

class _LiveVideoCardWidgetState extends State<LiveVideoCardWidget> with TickerProviderStateMixin {
  late final AnimationController _textBlinkController;
  late Animation<double> _textBlinkAnimation;
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  Future<void> _initRenderer() async {
    await _remoteRenderer.initialize();
  }

  @override
  void initState() {
    super.initState();
    _textBlinkController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
    )..repeat(reverse: true);

    _textBlinkAnimation = CurvedAnimation(
      parent: _textBlinkController,
      curve: Curves.easeInOut,
    );
    _initRenderer();
  }

  @override
  void dispose() {
    _textBlinkController.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext parentContext) {
    return BlocListener<WebRTCBloc, WebRTCState>(
      listener: (BuildContext listenerWebRTCcontext, WebRTCState listenerWebRTCstate) {
        if (listenerWebRTCstate is WebRTCConnected && listenerWebRTCstate.stream != null) {
          setState(() {
            _remoteRenderer.srcObject = listenerWebRTCstate.stream!;
          });
        }
      },
      child: BlocBuilder<WebRTCBloc, WebRTCState>(
        builder: (webRTCContext, webRTCState) {
          if (webRTCState is WebRTCConnected) {
            return Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(2, 2),
                    blurRadius: 20,
                    color: Colors.grey,
                  )
                ],
              ),
              child: Stack(
                children: [
                  Hero(
                    tag: "videoHero",
                    child: RTCVideoView(
                      _remoteRenderer,
                      filterQuality: FilterQuality.high,
                      objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      mirror: true,
                    ),
                  ),
                  BlocBuilder<CameraSelectCubit, CameraSelectState>(
                    builder: (cameraSelectContext, cameraSelectState) {
                      return Positioned(
                        bottom: 5,
                        right: 5,
                        child: IconButton(
                          icon: const Icon(
                            Icons.fullscreen_exit,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              useSafeArea: false,
                              builder: (dialogContext) {
                                return BlocProvider.value(
                                  value: BlocProvider.of<WebSocketBloc>(context),
                                  child: FullscreenVideoModal(
                                    videoRenderer: _remoteRenderer,
                                    selectCameraUuid: cameraSelectState.selectedCameraUuid!,
                                    currentUuid: cameraSelectState.uuid!,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: FadeTransition(
                      opacity: _textBlinkAnimation,
                      child: const Text(
                        "⦿ Live",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Colors.red,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
          if (webRTCState is WebRTCConnecting || webRTCState is WebRTCNew || webRTCState is WebRTCIntial) {
            return const LoadingStreamWidget();
          }
          return Container(
            //TODO: sections when connection closed;
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(2, 2),
                  blurRadius: 20,
                  color: Colors.grey,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
