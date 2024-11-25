import 'package:flutter/material.dart';
import 'package:gif/gif.dart';

class CameraNotSelectWidget extends StatefulWidget {
  const CameraNotSelectWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CameraNotSelectWidgetState createState() => _CameraNotSelectWidgetState();
}

class _CameraNotSelectWidgetState extends State<CameraNotSelectWidget> with TickerProviderStateMixin {
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
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            offset: Offset(2, 2),
            color: Colors.grey,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Gif(
            controller: _gifController,
            autostart: Autostart.loop,
            placeholder: (context) => const Center(child: CircularProgressIndicator()),
            width: 50,
            height: 50,
            fps: _fps,
            image: const AssetImage(
              "assets/icons/bored.gif",
            ),
          ),
          Text(
            "Vous n'avez pas choisir un caméra",
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
