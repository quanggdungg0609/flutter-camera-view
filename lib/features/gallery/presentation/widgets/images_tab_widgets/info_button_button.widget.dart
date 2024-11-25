import 'package:flutter/material.dart';
import 'package:flutter_camera_view/features/gallery/domain/entities/media_item.entity.dart';
import 'package:intl/intl.dart';

class InfoButtonButtonWidget extends StatefulWidget {
  final MediaItem mediaItem;
  const InfoButtonButtonWidget({super.key, required this.mediaItem});

  @override
  // ignore: library_private_types_in_public_api
  _InfoButtonButtonWidgetState createState() => _InfoButtonButtonWidgetState();
}

class _InfoButtonButtonWidgetState extends State<InfoButtonButtonWidget> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _showBubble() {
    final overlay = Overlay.of(context);
    if (overlay != null) {
      _overlayEntry = OverlayEntry(
        builder: (context) {
          return Positioned(
            width: 200, // Bubble width
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(5, -120),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name: ${widget.mediaItem.mediaName}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        "Size: ${_formatBytesToMB(widget.mediaItem.size)} bytes",
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        "Last Modified: ${_convertDateISO(widget.mediaItem.lastModified)}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
      overlay.insert(_overlayEntry!);
    }
  }

  String _convertDateISO(String date) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(date));
  }

  String _formatBytesToMB(int bytes) {
    double mb = bytes / (1024 * 1024);
    return mb.toStringAsFixed(2);
  }

  void _hideBubble() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTapDown: (_) {
          // Hiển thị bubble khi chạm vào button
          _showBubble();
        },
        onTapUp: (_) {
          // Ẩn bubble khi thả tay
          _hideBubble();
        },
        onTapCancel: () {
          // Ẩn bubble nếu chạm vào nhưng không thả tay
          _hideBubble();
        },
        child: IconButton(
          icon: const Icon(
            Icons.info,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            // Không cần xử lý onPressed vì đã sử dụng onTapDown và onTapUp
          },
        ),
      ),
    );
  }
}
