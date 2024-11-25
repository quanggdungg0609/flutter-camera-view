import 'package:flutter/material.dart';
import 'package:gif/gif.dart';

class LoadingStreamWidget extends StatefulWidget {
  const LoadingStreamWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoadingStreamWidgetState createState() => _LoadingStreamWidgetState();
}

class _LoadingStreamWidgetState extends State<LoadingStreamWidget> with TickerProviderStateMixin {
  late final GifController _gifController;
  final int _fps = 30;

  @override
  void initState() {
    _gifController = GifController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _gifController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Gif(
            controller: _gifController,
            image: const AssetImage(
              "assets/icons/loading.gif",
            ),
            autostart: Autostart.loop,
            placeholder: (context) => const Center(child: CircularProgressIndicator()),
            width: 100,
            height: 100,
            fps: _fps,
          ),
          Text(
            "Loading...",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w700,
              fontSize: 16,
              shadows: [
                Shadow(
                  offset: const Offset(1, 1),
                  blurRadius: 20,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
