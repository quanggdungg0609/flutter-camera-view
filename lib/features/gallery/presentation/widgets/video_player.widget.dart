import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart'; // Provides [VideoController] & [Video] etc.

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  // ignore: library_private_types_in_public_api
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late final controller = VideoController(player);

  final Player player = Player();

  @override
  void initState() {
    super.initState();
    final playable = Media(widget.videoUrl);
    player.open(playable, play: true);
  }

  @override
  void dispose() async {
    super.dispose();
    await player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          Video(
            controller: controller,
            aspectRatio: 16 / 9,
          ),
        ],
      ),
    ));
  }
}
