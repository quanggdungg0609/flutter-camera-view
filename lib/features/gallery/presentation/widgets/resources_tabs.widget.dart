import 'package:flutter/material.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/camera.entity.dart';
import 'package:flutter_camera_view/features/gallery/presentation/widgets/images_gallerie.widget.dart';

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
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.image),
              text: "Images",
            ),
            Tab(
              icon: Icon(Icons.video_collection),
            )
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            ImagesGallerieWidget(cameraUuid: widget.currentCamera.cameraUuid),
            const Text("Videos"),
          ],
        ),
      ),
    );
  }
}
