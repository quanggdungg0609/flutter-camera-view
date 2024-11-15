import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/bloc/camera_select_cubit/camera_select.cubit.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/bloc/websocket_bloc/websocket.bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:go_router/go_router.dart';
import 'package:star_menu/star_menu.dart';

// ignore: must_be_immutable
class FullscreenVideoModal extends StatefulWidget {
  final String currentUuid;
  final String selectCameraUuid;
  final RTCVideoRenderer videoRenderer;
  const FullscreenVideoModal({
    super.key,
    required this.videoRenderer,
    required this.currentUuid,
    required this.selectCameraUuid,
  });

  @override
  State<FullscreenVideoModal> createState() => _FullscreenVideoModalState();
}

class _FullscreenVideoModalState extends State<FullscreenVideoModal> with TickerProviderStateMixin {
  late final AnimationController _textBlinkController;
  late Animation<double> _textBlinkAnimation;
  late StarMenuController _menuController;

  bool _isRecord = false;
  @override
  void initState() {
    super.initState();
    _menuController = StarMenuController();
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _textBlinkController.dispose();
    _menuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Hero(
        tag: "videoHero",
        child: Container(
          color: Colors.black,
          width: size.width,
          height: size.height,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              RTCVideoView(
                widget.videoRenderer,
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              ),
              if (_isRecord)
                Positioned(
                  top: 20,
                  left: 60,
                  child: FadeTransition(
                    opacity: _textBlinkAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        "Rec",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
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
                  ),
                ),
              Positioned(
                top: 20,
                right: 20,
                child: StarMenu(
                  controller: _menuController,
                  items: [
                    _buildMenuItem(Icons.camera_alt, "Capture"),
                    !_isRecord
                        ? _buildMenuItem(Icons.video_camera_back, "Record")
                        : _buildMenuItem(Icons.stop, "Stop record"),
                  ],
                  onItemTapped: (index, controller) {
                    // TODO: record and capture image actions
                    switch (index) {
                      case 0:
                        final takeImageMessage = {
                          "event": "take-image",
                          "data": {
                            "from": widget.currentUuid,
                            "to": widget.selectCameraUuid,
                          },
                        };
                        BlocProvider.of<WebSocketBloc>(context).add(WsSendMessageEvent(message: takeImageMessage));
                        break;
                      case 1:
                        if (_isRecord) {
                          final stopRecordMessage = {
                            "event": "stop-record",
                            "data": {
                              "from": widget.currentUuid,
                              "to": widget.selectCameraUuid,
                            }
                          };
                          BlocProvider.of<WebSocketBloc>(context).add(WsSendMessageEvent(message: stopRecordMessage));
                        } else {
                          final startRecordMessage = {
                            "event": "start-record",
                            "data": {
                              "from": widget.currentUuid,
                              "to": widget.selectCameraUuid,
                            }
                          };
                          BlocProvider.of<WebSocketBloc>(context).add(WsSendMessageEvent(message: startRecordMessage));
                        }
                        setState(
                          () {
                            _isRecord = !_isRecord;
                          },
                        );
                        break;
                    }
                  },
                  params: StarMenuParameters.arc(
                    ArcType.quarterBottomLeft,
                    radiusX: 80,
                    radiusY: 80,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: IconButton(
                  icon: const Icon(
                    Icons.fullscreen_exit,
                    size: 30,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 20,
                      )
                    ],
                  ),
                  onPressed: () {
                    context.pop();
                  },
                ),
              ),
              Positioned(
                bottom: 20,
                left: 60,
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
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 30),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
