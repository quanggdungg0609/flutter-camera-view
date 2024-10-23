import 'package:dio/dio.dart';
import 'package:flutter_camera_view/core/exceptions/auth_datasource.exception.dart';
import 'package:flutter_camera_view/features/login/data/models/login_response.model.dart';
import 'package:flutter_camera_view/features/login/data/models/tokens.model.dart';
import 'package:flutter_camera_view/features/login/data/models/user_info.model.dart';
import 'package:flutter_camera_view/features/login/domain/entities/login_response.entity.dart';
import 'package:flutter_camera_view/features/login/domain/entities/user_info.entity.dart';

abstract class AuthDataSource {
  Future<LoginResponse> login(String account, String password);
  Future<UserInfo> getMyInfo();
}

class AuthDatasSourceImpl implements AuthDataSource {
  final Dio dio;

  AuthDatasSourceImpl({required this.dio});

  @override
  Future<UserInfo> getMyInfo() {
    // TODO: implement getMyInfo
    throw UnimplementedError();
  }

  @override
  Future<LoginResponseModel> login(String account, String password) async {
    try {
      var response = await dio.post("/auth/login/", data: {
        "username": account,
        "password": password,
      });

      UserInfoModel userInfo = UserInfoModel.fromJson(response.data);
      RefreshTokenModel refreshToken = RefreshTokenModel.fromJson(response.data);
      AccessTokenModel accessToken = AccessTokenModel.fromJson(response.data);
      return LoginResponseModel(userInfo: userInfo, accessToken: accessToken, refreshToken: refreshToken);
    } catch (_) {
      throw FailedToLogin();
    }
  }
}
