import 'package:flutter_camera_view/core/constants/constants.dart';
import 'package:flutter_camera_view/core/exceptions/local_datasource.exception.dart';
import 'package:flutter_camera_view/features/login/data/models/tokens.model.dart';
import 'package:flutter_camera_view/features/login/domain/entities/account_info.entity.dart';
import 'package:flutter_camera_view/features/login/domain/entities/tokens.entity.dart';
import 'package:flutter_camera_view/features/login/domain/entities/user_info.entity.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

abstract class LocalDataSource {
  Future<void> saveToken(AccessToken accessToken, RefreshToken refreshToken);
  Future<void> updateAccessToken(AccessToken token);

  Future<void> saveAccountInfo(AccountInfo accountInfo);
  Future<AccountInfo> getAccountInfo();
  Future<void> clearAccountInfo();

  Future<AccessToken?> getAccessToken();
  Future<RefreshToken?> getRefreshToken();

  Future<UserInfo> getUserInfo();
  Future<void> clearTokens();
}

class LocalDataSourceImpl implements LocalDataSource {
  final FlutterSecureStorage secureStorage;
  final BoxCollection hiveCollections;

  LocalDataSourceImpl({required this.secureStorage, required this.hiveCollections});

  @override
  Future<void> clearTokens() async {
    // clear all token in secure storage
    try {
      await secureStorage.delete(key: RTOKEN);
      await secureStorage.delete(key: ATOKEN);
    } catch (_) {
      throw FailedToClearTokens();
    }
  }

  @override
  Future<void> saveToken(AccessToken accessToken, RefreshToken refreshToken) async {
    // save access token and refresh token in secure storage
    try {
      await secureStorage.write(key: ATOKEN, value: accessToken.value);
      await secureStorage.write(key: RTOKEN, value: refreshToken.value);
    } catch (_) {}
  }

  @override
  Future<UserInfo> getUserInfo() {
    // TODO: implement getUserInfo
    throw UnimplementedError();
  }

  @override
  Future<AccessToken?> getAccessToken() async {
    try {
      String? tokenValue = await secureStorage.read(key: ATOKEN);
      if (tokenValue == null) {
        return null;
      }
      AccessToken token = AccessTokenModel(value: tokenValue);
      return token;
    } catch (_) {
      throw FailedToGetTokens(message: "Failed to get Access Token");
    }
  }

  @override
  Future<RefreshToken?> getRefreshToken() async {
    try {
      String? tokenValue = await secureStorage.read(key: RTOKEN);
      if (tokenValue == null) {
        return null;
      }
      RefreshTokenModel token = RefreshTokenModel(value: tokenValue);
      return token;
    } catch (_) {
      throw FailedToGetTokens(message: "Failed to get Refresh Token");
    }
  }

  @override
  Future<void> updateAccessToken(AccessToken token) async {
    // update new access token
    try {
      await secureStorage.write(key: ATOKEN, value: token.value);
    } catch (_) {
      throw FailedToUpdateToken();
    }
  }

  @override
  Future<AccountInfo> getAccountInfo() {
    // TODO: implement getAccountInfo
    throw UnimplementedError();
  }

  @override
  Future<void> saveAccountInfo(AccountInfo accountInfo) {
    // get account id and password saved in secure storage
    // TODO: implement saveAccountInfo
    throw UnimplementedError();
  }

  @override
  Future<void> clearAccountInfo() {
    // TODO: implement clearAccountInfo
    throw UnimplementedError();
  }
}
