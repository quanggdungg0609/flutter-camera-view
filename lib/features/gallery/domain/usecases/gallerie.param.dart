class GallerieParams {
  final String cameraUuid;
  final List<String> mediaNames;
  final bool isVideo;

  GallerieParams({required this.cameraUuid, required this.mediaNames, this.isVideo = false});
}
