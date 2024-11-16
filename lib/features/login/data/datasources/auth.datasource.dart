import 'package:dio/dio.dart';
import 'package:flutter_camera_view/core/exceptions/auth_datasource.exception.dart';
import 'package:flutter_camera_view/features/login/data/models/login_response.model.dart';
import 'package:flutter_camera_view/features/login/data/models/tokens.model.dart';
import 'package:flutter_camera_view/features/login/data/models/user_info.model.dart';
import 'package:flutter_camera_view/features/login/domain/entities/account_info.entity.dart';
import 'package:flutter_camera_view/features/login/domain/entities/login_response.entity.dart';

abstract class AuthDataSource {
  Future<LoginResponse> login(AccountInfo accountInfo);
}

class AuthDatasSourceImpl implements AuthDataSource {
  final Dio dio;

  AuthDatasSourceImpl({required this.dio});

  @override
  Future<LoginResponseModel> login(AccountInfo accountInfo) async {
    try {
      Response response = await dio.post("/auth/login/", data: {
        "username": accountInfo.accountID,
        "password": accountInfo.password,
      });

      Map<String, dynamic> json = response.data;

      UserInfoModel userInfo = UserInfoModel.fromJson(json);
      RefreshTokenModel refreshToken = RefreshTokenModel.fromJson(json);
      AccessTokenModel accessToken = AccessTokenModel.fromJson(json);
      return LoginResponseModel(userInfo: userInfo, accessToken: accessToken, refreshToken: refreshToken);
    } catch (e) {
      throw FailedToLoginException();
    }
  }
}
