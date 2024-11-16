import 'package:flutter_camera_view/features/login/domain/entities/login_response.entity.dart';

class LoginResponseModel extends LoginResponse {
  const LoginResponseModel({required super.userInfo, required super.accessToken, required super.refreshToken});
}
