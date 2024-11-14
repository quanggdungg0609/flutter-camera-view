import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/bloc/webrtc_bloc/webrtc.bloc.dart';
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
  bool _inView = false;
  MediaStream? _currentStream;

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

  void _toggleFullScreen() async {
    await showDialog(
      context: context,
      useSafeArea: false,
      builder: (dialogContext) {
        return FullscreenVideoModal(videoRenderer: _remoteRenderer);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WebRTCBloc, WebRTCState>(
      listener: (BuildContext context, WebRTCState state) {
        if (state is WebRTCConnected && state.stream != null) {
          setState(() {
            _remoteRenderer.srcObject = state.stream!;
            _currentStream = state.stream;
            _inView = true;
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
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: IconButton(
                      icon: const Icon(
                        Icons.fullscreen_exit,
                        color: Colors.white,
                      ),
                      onPressed: _toggleFullScreen,
                    ),
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
