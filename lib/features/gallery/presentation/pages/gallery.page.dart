import 'package:flutter/material.dart';
import 'package:flutter_camera_view/features/gallery/data/datasources/gallerie.datasource.dart';
import 'package:flutter_camera_view/injection_container.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    sl<GallerieDataSource>().getMediaPage("48f797c7-3e0d-427c-b23c-8d6400841d05").then(
      (page) async {
        print(page.fileNames);
        final list =
            await sl<GallerieDataSource>().getMediaInfos("48f797c7-3e0d-427c-b23c-8d6400841d05", page.fileNames);
        print(list);
      },
    );

    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
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
          ],
        ),
      ),
    );
  }
}
