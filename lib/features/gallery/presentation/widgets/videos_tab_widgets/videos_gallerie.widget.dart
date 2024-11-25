import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/media_item.entity.dart';
import 'package:flutter_camera_view/features/gallery/presentation/blocs/gallerie_bloc/gallerie.bloc.dart';
import 'package:flutter_camera_view/features/gallery/presentation/widgets/images_tab_widgets/images_gallerie.widget.dart';
import 'package:flutter_camera_view/injection_container.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

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
        listener: (gallerieContext, gallerieState) {},
      ),
    );
  }
}
