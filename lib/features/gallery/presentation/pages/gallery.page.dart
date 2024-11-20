import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/features/gallery/data/datasources/gallerie.datasource.dart';
import 'package:flutter_camera_view/features/gallery/presentation/blocs/camera_select_cubit/resource_select.cubit.dart';
import 'package:flutter_camera_view/features/gallery/presentation/widgets/resource_select.widget.dart';
import 'package:flutter_camera_view/injection_container.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
          child: MultiBlocProvider(
        providers: [
          BlocProvider<ResourceSelectCubit>(
            create: (context) => sl<ResourceSelectCubit>(),
          ),
        ],
        child: const Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, top: 10),
              child: Text(
                "Gallerie",
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(color: Colors.grey, offset: Offset(1, 1), blurRadius: 10),
                  ],
                ),
              ),
            ),
            ResourceSelectWidget(),
          ],
        ),
      )),
    );
  }
}
