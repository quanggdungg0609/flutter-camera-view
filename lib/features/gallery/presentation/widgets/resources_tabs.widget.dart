import 'package:flutter/material.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/camera.entity.dart';
import 'package:flutter_camera_view/features/gallery/presentation/widgets/images_tab_widgets/images_gallerie.widget.dart';
import 'package:flutter_camera_view/features/gallery/presentation/widgets/videos_tab_widgets/videos_gallerie.widget.dart';

class ResourcesTabsWidget extends StatefulWidget {
  final Camera currentCamera;
  const ResourcesTabsWidget({super.key, required this.currentCamera});

  @override
  // ignore: library_private_types_in_public_api
  _ResourcesTabsWidgetState createState() => _ResourcesTabsWidgetState();
}

class _ResourcesTabsWidgetState extends State<ResourcesTabsWidget> with TickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(children: [
        TabBar(
          splashFactory: NoSplash.splashFactory,
          controller: _tabController,
          dividerColor: Colors.transparent,
          labelColor: Colors.white,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(
              icon: Icon(
                Icons.image,
                shadows: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(1, 1),
                    blurRadius: 10,
                  )
                ],
              ),
            ),
            Tab(
              icon: Icon(
                Icons.video_collection,
                shadows: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(1, 1),
                    blurRadius: 10,
                  )
                ],
              ),
            )
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              ImagesGallerieWidget(cameraUuid: widget.currentCamera.cameraUuid),
              VideosGallerieWidget(cameraUuid: widget.currentCamera.cameraUuid),
            ],
          ),
        ),
      ]),
    );
  }
}
