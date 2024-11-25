import 'package:flutter/material.dart';
import 'package:gif/gif.dart';

class NoResourceSelectedWidget extends StatefulWidget {
  const NoResourceSelectedWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NoResourceSelectedWidgetState createState() => _NoResourceSelectedWidgetState();
}

class _NoResourceSelectedWidgetState extends State<NoResourceSelectedWidget> with TickerProviderStateMixin {
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
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Gif(
            controller: _gifController,
            image: const AssetImage("assets/icons/president.gif"),
            autostart: Autostart.loop,
            width: 100,
            height: 100,
            fps: _fps,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "Aucune ressource n'a encore été sélectionnée",
              textAlign: TextAlign.center,
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
          ),
        ],
      ),
    );
  }
}
