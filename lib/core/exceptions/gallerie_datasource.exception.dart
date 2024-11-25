class GetCamerasException implements Exception {}

class GetMediaPageException implements Exception {
  final String message;
  const GetMediaPageException({required this.message});
}

class GetMediaInfosException implements Exception {
  final String message;
  const GetMediaInfosException({required this.message});
}

class GetMediaUrlsException implements Exception {
  final String message;

  const GetMediaUrlsException({required this.message});
}

class GetVideoThumbnaisException implements Exception {}
