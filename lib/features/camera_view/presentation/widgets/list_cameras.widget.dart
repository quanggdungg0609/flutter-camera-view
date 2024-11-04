import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/bloc/websocket_bloc/websocket.bloc.dart';

class ListCameras extends StatefulWidget {
  const ListCameras({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ListCamerasWidgetState createState() => _ListCamerasWidgetState();
}

class _ListCamerasWidgetState extends State<ListCameras> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: BlocBuilder<WebSocketBloc, WebSocketState>(
        builder: (wsContext, wsState) {
          print(wsState);
          return Container();
        },
      ),
    );
  }
}
