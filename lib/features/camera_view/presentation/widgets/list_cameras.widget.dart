import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/bloc/webrtc_bloc/webrtc.bloc.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/bloc/websocket_bloc/websocket.bloc.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/widgets/camera_card.widget.dart';

class ListCamerasWidget extends StatefulWidget {
  const ListCamerasWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ListCamerasWidgetState createState() => _ListCamerasWidgetState();
}

class _ListCamerasWidgetState extends State<ListCamerasWidget> with WidgetsBindingObserver {
  String _currentCameraUuid = "";

  @override
  void initState() {
    super.initState();
    // Listen to WebRTCBloc and set the current camera UUID if it's not set.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final webRTCBloc = BlocProvider.of<WebRTCBloc>(context);
      if (webRTCBloc.currentCameraUUID.isEmpty) {
        setState(() {
          _currentCameraUuid = webRTCBloc.currentCameraUUID;
        });
        webRTCBloc.add(
          SelectCurrentCameraEvent(currentCameraUuid: webRTCBloc.currentCameraUUID),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WebSocketBloc, WebSocketState>(
      builder: (wsContext, wsState) {
        if (wsState is WsConnected) {
          return BlocBuilder<WebRTCBloc, WebRTCState>(
            builder: (webRTCContext, webRTCstate) {
              print(BlocProvider.of<WebRTCBloc>(webRTCContext).currentCameraUUID);
              return ListView.builder(
                itemCount: wsState.listCameras.length,
                itemBuilder: (listBuilderContext, index) {
                  if (wsState.listCameras[index].uuid == _currentCameraUuid) {
                    return Text(wsState.listCameras[index].name);
                  }
                  return CameraCardWidget(cameraInfo: wsState.listCameras[index]);
                },
              );
            },
          );
        }
        return Container();
      },
    );
  }
}
