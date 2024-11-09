import 'package:flutter/material.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/camera_info.entity.dart';

// ignore: must_be_immutable
class CameraCardWidget extends StatelessWidget {
  final CameraInfo cameraInfo;
  final bool isActive;

  CameraCardWidget({
    super.key,
    required this.cameraInfo,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.all(5),
      height: screenHeight / 8,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
          child: Row(
            children: [
              const ImageIcon(
                AssetImage("assets/icons/live.png"),
                size: 80,
                color: Colors.redAccent,
              ),
              VerticalDivider(
                color: Colors.grey.shade400,
                width: 30,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cameraInfo.name,
                    style: TextStyle(
                      color: Colors.blueAccent.shade400,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    cameraInfo.location,
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
