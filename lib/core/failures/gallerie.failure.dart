import 'package:flutter_camera_view/core/failures/failure.dart';

class GetListCamerasFailure extends Failure {}

class GetListMediaInfos extends Failure {
  final bool isVideo;

  GetListMediaInfos({required this.isVideo});

  @override
  List<Object?> get props => [isVideo];
}

class GetMediaPageFailure extends Failure {
  final bool isVideo;

  GetMediaPageFailure({required this.isVideo});

  @override
  List<Object?> get props => [isVideo];
}

class GetMediaUrlsFailure extends Failure {
  final bool isVideo;

  GetMediaUrlsFailure({required this.isVideo});

  @override
  List<Object?> get props => [isVideo];
}

class GetVideoThumbnailsFailure extends Failure {}

class GetMediaItemsFailure extends Failure {
  final bool isVideo;

  GetMediaItemsFailure({required this.isVideo});

  @override
  List<Object?> get props => [isVideo];
}
