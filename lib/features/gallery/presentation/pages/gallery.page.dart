import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/features/gallery/presentation/blocs/camera_select_cubit/resource_select.cubit.dart';
import 'package:flutter_camera_view/features/gallery/presentation/widgets/media_view_tabs.widget.dart';
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
            create: (context) => sl<ResourceSelectCubit>()..getListCameras(),
          ),
        ],
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
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
                  ResourceSelectWidget(),
                ],
              ),
            ),
            MediaViewTabsWidget()
          ],
        ),
      )),
    );
  }
}
