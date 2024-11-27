import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/media_item.entity.dart';
import 'package:flutter_camera_view/features/gallery/presentation/blocs/gallerie_bloc/gallerie.bloc.dart';

import 'package:flutter_camera_view/features/gallery/presentation/widgets/video_player.widget.dart';
import 'package:flutter_camera_view/injection_container.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class VideosGallerieWidget extends StatefulWidget {
  final String cameraUuid;

  const VideosGallerieWidget({super.key, required this.cameraUuid});

  @override
  // ignore: library_private_types_in_public_api
  _VideosGallerieWidgetState createState() => _VideosGallerieWidgetState();
}

class _VideosGallerieWidgetState extends State<VideosGallerieWidget> {
  final GallerieBloc _gallerieBloc = sl<GallerieBloc>();
  final PagingController<int, MediaItem> _pagingController = PagingController(firstPageKey: 1);
  final ValueNotifier<List<MediaItem>> _mediaItemsNotifier = ValueNotifier([]);
  final ValueNotifier<MediaItem?> _currentMediaItemNotifier = ValueNotifier(null);
  // states

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener(_requestListener);
  }

  void _requestListener(int pageKey) {
    const pageSize = 4;

    _gallerieBloc.add(
      GallerieFetchMediasEvent(cameraUuid: widget.cameraUuid, page: pageKey, limit: pageSize, isVideo: true),
    );
  }

  @override
  void didUpdateWidget(covariant VideosGallerieWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cameraUuid != oldWidget.cameraUuid) {
      // Reset  PagingController
      _pagingController.itemList = null;
      _pagingController.removePageRequestListener(_requestListener);
      _pagingController.nextPageKey = _pagingController.firstPageKey;
      _mediaItemsNotifier.value = [];
      _pagingController.refresh();
    }
  }

  @override
  void dispose() {
    _mediaItemsNotifier.dispose();
    _currentMediaItemNotifier.dispose();
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
            final newItems = List<MediaItem>.from(_mediaItemsNotifier.value)..addAll(gallerieState.items);

            _mediaItemsNotifier.value = newItems;
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
          builderDelegate: PagedChildBuilderDelegate(itemBuilder: (pageChildBuilderContext, item, index) {
            return GestureDetector(
              onTap: () {
                _currentMediaItemNotifier.value = item;
                // showModal depend media type
                _showMediaModal(pageChildBuilderContext, index);
              },
              child: Hero(
                tag: item.mediaUrl,
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: item.videoThumbnail != null ? item.videoThumbnail! : item.mediaUrl,
                        placeholder: (context, url) => Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: const BoxDecoration(color: Colors.black54),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
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
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void _showMediaModal(BuildContext context, int initialIndex) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return ValueListenableBuilder(
          valueListenable: _mediaItemsNotifier,
          builder: (context, items, _) {
            return Dialog(
              insetPadding: EdgeInsets.zero,
              backgroundColor: Colors.black26,
              child: StatefulBuilder(
                builder: (context, setModalState) {
                  MediaItem currentMediaItem = items[initialIndex];
                  return Stack(
                    children: [
                      currentMediaItem.videoThumbnail != null
                          ? VideoPlayerWidget(videoUrl: currentMediaItem.mediaUrl)
                          : PhotoViewGallery.builder(
                              itemCount: items.length,
                              pageController: PageController(initialPage: initialIndex),
                              builder: (context, index) {
                                if (index == items.length - 1 && _pagingController.nextPageKey != null) {
                                  _loadNextPage();
                                }
                                final mediaItem = items[index];
                                return PhotoViewGalleryPageOptions(
                                  imageProvider: CachedNetworkImageProvider(mediaItem.mediaUrl),
                                  heroAttributes: PhotoViewHeroAttributes(tag: mediaItem.mediaUrl),
                                );
                              },
                              scrollPhysics: const BouncingScrollPhysics(),
                              backgroundDecoration: const BoxDecoration(
                                color: Colors.black26,
                              ),
                              onPageChanged: (index) {
                                // Verify if is last image
                                if (index == items.length - 1 && _pagingController.nextPageKey != null) {
                                  _loadNextPage();
                                }
                                setModalState(
                                  () {
                                    currentMediaItem = items[index];
                                  },
                                );
                                // Update the currentMediaItemNotifier
                                _currentMediaItemNotifier.value = currentMediaItem;
                              },
                            ),
                    ],
                  );
                },
              ),
            );
          },
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0; // Start scale
        const end = 1.0; // End scale
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var scaleAnimation = animation.drive(tween);

        return ScaleTransition(scale: scaleAnimation, child: child);
      },
    );
  }

  void _loadNextPage() {
    final nextPageKey = _pagingController.nextPageKey;
    if (nextPageKey != null) {
      _pagingController.notifyPageRequestListeners(nextPageKey);
    }
  }
}
