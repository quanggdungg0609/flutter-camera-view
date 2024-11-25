import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/media_item.entity.dart';
import 'package:flutter_camera_view/features/gallery/presentation/blocs/gallerie_bloc/gallerie.bloc.dart';
import 'package:flutter_camera_view/features/gallery/presentation/widgets/images_tab_widgets/info_button_button.widget.dart';
import 'package:flutter_camera_view/injection_container.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

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
      GallerieFetchMediasEvent(cameraUuid: widget.cameraUuid, page: pageKey, limit: pageSize, isVideo: false),
    );
  }

  @override
  void didUpdateWidget(covariant ImagesGallerieWidget oldWidget) {
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
          builderDelegate: PagedChildBuilderDelegate<MediaItem>(
            itemBuilder: (pageChildBuilderContext, item, index) {
              return GestureDetector(
                onTap: () {
                  _currentMediaItemNotifier.value = item;
                  _showImageModal(pageChildBuilderContext, index);
                },
                child: Hero(
                  tag: item.mediaUrl,
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: item.mediaUrl,
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
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showImageModal(BuildContext context, int initialIndex) {
    showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return ValueListenableBuilder<List<MediaItem>>(
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
                      PhotoViewGallery.builder(
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
                      Positioned(
                        top: 80,
                        left: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ValueListenableBuilder(
                                valueListenable: _currentMediaItemNotifier,
                                builder: (context, item, _) {
                                  return Text(
                                    item!.mediaName,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  );
                                },
                              ),
                              IconButton(
                                onPressed: () => context.pop(),
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 110,
                        left: 15,
                        child: ValueListenableBuilder(
                          valueListenable: _currentMediaItemNotifier,
                          builder: (context, currentMediaItem, _) {
                            if (currentMediaItem == null) return const SizedBox.shrink();
                            return InfoButtonButtonWidget(mediaItem: currentMediaItem);
                          },
                        ),
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
