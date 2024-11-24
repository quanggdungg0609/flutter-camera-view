import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/media_item.entity.dart';
import 'package:flutter_camera_view/features/gallery/presentation/blocs/gallerie_bloc/gallerie.bloc.dart';
import 'package:flutter_camera_view/injection_container.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ImagesGallerieWidget extends StatefulWidget {
  final String cameraUuid;

  const ImagesGallerieWidget({super.key, required this.cameraUuid});

  @override
  // ignore: library_private_types_in_public_api
  _ImagesGallerieWidgetState createState() => _ImagesGallerieWidgetState();
}

class _ImagesGallerieWidgetState extends State<ImagesGallerieWidget> {
  final GallerieBloc _gallerieBloc = sl<GallerieBloc>();
  final PagingController<int, MediaItem> _pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener(
      (pageKey) {
        print("Requesting page: $pageKey for cameraUuid: ${widget.cameraUuid}");
        const pageSize = 4;

        _gallerieBloc.add(
          GallerieFetchMediasEvent(cameraUuid: widget.cameraUuid, page: pageKey, limit: pageSize, isVideo: false),
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant ImagesGallerieWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cameraUuid != oldWidget.cameraUuid) {
      // Reset  PagingController
      _pagingController.itemList = null;

      _pagingController.nextPageKey = _pagingController.firstPageKey;
      _pagingController.refresh();
    }
  }

  @override
  void dispose() {
    _pagingController.itemList = null; // Clear old items
    _pagingController.nextPageKey = _pagingController.firstPageKey;
    _pagingController.refresh();

    _pagingController.dispose();
    _gallerieBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _gallerieBloc,
      child: BlocListener<GallerieBloc, GallerieState>(
        listener: (gallerieContext, gallerieState) {
          if (gallerieState is GallerieMediaFetchedState) {
            final isLastPage = gallerieState.mediaPage.nextPage == null;
            if (isLastPage) {
              _pagingController.appendLastPage(gallerieState.items);
            } else {
              _pagingController.appendPage(gallerieState.items, gallerieState.mediaPage.nextPage);
            }
          }
        },
        child: PagedGridView<int, MediaItem>(
          pagingController: _pagingController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          builderDelegate: PagedChildBuilderDelegate<MediaItem>(itemBuilder: (pageChildBuilderContext, item, index) {
            return Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: item.mediaUrl, // Mã hóa URL nếu cần
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  height: double.infinity,
                  width: double.infinity,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
                Positioned(
                  left: 4,
                  bottom: 1,
                  child: Text(
                    item.mediaName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      shadows: [
                        Shadow(
                          color: Colors.grey,
                          offset: Offset(0.2, 0.2),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
