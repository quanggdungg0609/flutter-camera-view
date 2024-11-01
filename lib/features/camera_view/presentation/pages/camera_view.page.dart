import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CameraViewPage extends StatelessWidget {
  const CameraViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MultiBlocProvider(
        providers: [],
        child: Container(),
      ),
    );
  }
}
