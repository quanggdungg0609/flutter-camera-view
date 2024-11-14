import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class FullscreenVideoModal extends StatefulWidget {
  final RTCVideoRenderer videoRenderer;
  const FullscreenVideoModal({super.key, required this.videoRenderer});

  @override
  State<FullscreenVideoModal> createState() => _FullscreenVideoModalState();
}

class _FullscreenVideoModalState extends State<FullscreenVideoModal> with TickerProviderStateMixin {
  late final AnimationController _textBlinkController;
  late Animation<double> _textBlinkAnimation;

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
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    _textBlinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Enable immersive full-screen mode and landscape orientation

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
}
