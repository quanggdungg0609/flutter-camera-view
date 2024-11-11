import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/bloc/websocket_bloc/websocket.bloc.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/widgets/connect_failed.widget.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/widgets/list_cameras.widget.dart';

class CamerasSection extends StatefulWidget {
  const CamerasSection({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ListCamerasWidgetState createState() => _ListCamerasWidgetState();
}

class _ListCamerasWidgetState extends State<CamerasSection> {
  bool isRequestCamera = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: BlocBuilder<WebSocketBloc, WebSocketState>(
        builder: (wsContext, wsState) {
          if (wsState is WsConnected) {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "List des caméras",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: Colors.black54,
                      shadows: [
                        Shadow(
                          color: Colors.white,
                          offset: Offset(1, 1),
                          blurRadius: 20,
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(child: ListCamerasWidget()),
              ],
            );
          } else {
            return const ConnectFailedWidget();
          }
        },
      ),
    );
  }
}
