import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/features/camera_view/domain/entities/camera_info.entity.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/bloc/camera_select_cubit/camera_select.cubit.dart';

// ignore: must_be_immutable
class CameraCardWidget extends StatelessWidget {
  final CameraInfo cameraInfo;
  final bool isActive;

  const CameraCardWidget({
    super.key,
    required this.cameraInfo,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: isActive
          ? () {
              BlocProvider.of<CameraSelectCubit>(context).selectCamera(cameraInfo.uuid);
            }
          : null,
      child: Container(
        padding: const EdgeInsets.all(5),
        height: screenHeight / 8,
        child: Card(
          color: isActive ? Colors.white : Colors.grey.shade200,
          elevation: isActive ? 5 : 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            child: Row(
              children: [
                ImageIcon(
                  const AssetImage("assets/icons/live.png"),
                  size: 80,
                  color: isActive ? Colors.redAccent : Colors.grey,
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
                        color: isActive ? Colors.blueAccent.shade400 : Colors.grey.shade500,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      cameraInfo.location,
                      style: TextStyle(
                        color: isActive ? Colors.grey.shade800 : Colors.grey.shade400,
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
      ),
    );
  }
}
