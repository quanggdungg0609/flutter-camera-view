import 'package:equatable/equatable.dart';
import 'package:flutter_camera_view/features/login/domain/entities/tokens.entity.dart';
import 'package:flutter_camera_view/features/login/domain/entities/user_info.entity.dart';

abstract class LoginResponse extends Equatable {
  final AccessToken accessToken;
  final RefreshToken refreshToken;
  final UserInfo userInfo;

  const LoginResponse({required this.accessToken, required this.refreshToken, required this.userInfo});

  @override
  List<Object?> get props => [
        refreshToken,
        accessToken,
        userInfo,
      ];
}
