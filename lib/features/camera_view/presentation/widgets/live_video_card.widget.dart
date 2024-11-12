import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/features/camera_view/presentation/bloc/webrtc_bloc/webrtc.bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class LiveVideoCardWidget extends StatefulWidget {
  const LiveVideoCardWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LiveVideoCardWidgetState createState() => _LiveVideoCardWidgetState();
}

class _LiveVideoCardWidgetState extends State<LiveVideoCardWidget> {
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool _inView = false;

  Future<void> _initRenderer() async {
    await _remoteRenderer.initialize();
  }

  @override
  void initState() {
    super.initState();
    _initRenderer();
  }

  @override
  void dispose() {
    super.dispose();
    _remoteRenderer.dispose();
    BlocProvider.of<WebRTCBloc>(context).add(WebRTCDisconnectingEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WebRTCBloc, WebRTCState>(
      listener: (BuildContext context, WebRTCState state) {},
    );
  }
}
