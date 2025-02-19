import 'package:flutter_camera_view/features/login/domain/entities/tokens.entity.dart';

class AccessTokenModel extends AccessToken {
  const AccessTokenModel({required super.value});

  factory AccessTokenModel.fromJson(Map<String, dynamic> json) {
    return AccessTokenModel(value: json["access"]);
  }
}

class RefreshTokenModel extends RefreshToken {
  const RefreshTokenModel({required super.value});

  factory RefreshTokenModel.fromJson(Map<String, dynamic> json) {
    return RefreshTokenModel(value: json["refresh"]);
  }
}
