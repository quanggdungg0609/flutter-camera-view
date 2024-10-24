import 'package:flutter_camera_view/core/constants/constants.dart';
import 'package:flutter_camera_view/core/exceptions/local_datasource.exception.dart';
import 'package:flutter_camera_view/features/login/data/models/account_info.model.dart';
import 'package:flutter_camera_view/features/login/data/models/tokens.model.dart';
import 'package:flutter_camera_view/features/login/data/models/user_info.model.dart';
import 'package:flutter_camera_view/features/login/domain/entities/account_info.entity.dart';
import 'package:flutter_camera_view/features/login/domain/entities/tokens.entity.dart';
import 'package:flutter_camera_view/features/login/domain/entities/user_info.entity.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

abstract class LocalDataSource {
  /// Saves the access token and refresh token in secure storage.
  Future<void> saveToken(AccessToken accessToken, RefreshToken refreshToken);

  /// Updates the access token in secure storage.
  Future<void> updateAccessToken(AccessToken token);

  /// Clears the access token and refresh token from secure storage.
  Future<void> clearTokens();

  /// Saves the account information (username and password) in secure storage.
  Future<void> saveAccountInfo(AccountInfo accountInfo);

  /// Retrieves the account information (username and password) from secure storage.
  Future<AccountInfo?> getAccountInfo();

  /// Clears the account information from secure storage.
  Future<void> clearAccountInfo();

  /// Retrieves the access token from secure storage.
  Future<AccessToken?> getAccessToken();

  /// Retrieves the refresh token from secure storage.
  Future<RefreshToken?> getRefreshToken();

  /// Saves the user information in Hive database.
  Future<void> saveUserInfo(UserInfo userInfo);

  /// Retrieves the user information from Hive database.
  Future<UserInfo?> getUserInfo();

  /// Clears the user information from Hive database.
  Future<void> clearUserInfo();
}

class LocalDataSourceImpl implements LocalDataSource {
  final FlutterSecureStorage secureStorage;
  final BoxCollection hiveCollections;

  LocalDataSourceImpl({required this.secureStorage, required this.hiveCollections});

  @override
  Future<void> clearTokens() async {
    // Deletes both access and refresh tokens from secure storage.
    try {
      await secureStorage.delete(key: RTOKEN);
      await secureStorage.delete(key: ATOKEN);
    } catch (_) {
      throw ClearTokensException();
    }
  }

  @override
  Future<void> saveToken(AccessToken accessToken, RefreshToken refreshToken) async {
    // Saves access and refresh tokens in secure storage.
    try {
      await secureStorage.write(key: ATOKEN, value: accessToken.value);
      await secureStorage.write(key: RTOKEN, value: refreshToken.value);
    } catch (_) {}
  }

  @override
  Future<AccessToken?> getAccessToken() async {
    // Retrieves the access token from secure storage.
    try {
      String? tokenValue = await secureStorage.read(key: ATOKEN);
      if (tokenValue == null) {
        return null;
      }
      AccessToken token = AccessTokenModel(value: tokenValue);
      return token;
    } catch (_) {
      throw GetTokensException(message: "Failed to get Access Token");
    }
  }

  @override
  Future<RefreshToken?> getRefreshToken() async {
    // Retrieves the refresh token from secure storage.
    try {
      String? tokenValue = await secureStorage.read(key: RTOKEN);
      if (tokenValue == null) {
        return null;
      }
      RefreshTokenModel token = RefreshTokenModel(value: tokenValue);
      return token;
    } catch (_) {
      throw GetTokensException(message: "Failed to get Refresh Token");
    }
  }

  @override
  Future<void> updateAccessToken(AccessToken token) async {
    // Updates the access token in secure storage.
    try {
      await secureStorage.write(key: ATOKEN, value: token.value);
    } catch (_) {
      throw UpdateTokenException();
    }
  }

  @override
  Future<AccountInfo?> getAccountInfo() async {
    // Retrieves account information (username and password) from secure storage.
    try {
      final accountID = await secureStorage.read(key: ACCOUNT);
      final password = await secureStorage.read(key: PASSWORD);

      if (accountID != null && password != null) {
        final AccountInfoModel accountInfo = AccountInfoModel(accountID: accountID, password: password);
        return accountInfo;
      }
      return null;
    } catch (_) {
      throw GetAccoutInfoException();
    }
  }

  @override
  Future<void> saveAccountInfo(AccountInfo accountInfo) async {
    // Saves account information (username and password) in secure storage.
    try {
      await secureStorage.write(key: ACCOUNT, value: accountInfo.accountID);
      await secureStorage.write(key: PASSWORD, value: accountInfo.password);
    } catch (_) {
      throw SaveAccountInfoException();
    }
  }

  @override
  Future<void> clearAccountInfo() async {
    // Deletes account information (username and password) from secure storage.
    try {
      await secureStorage.delete(key: ACCOUNT);
      await secureStorage.delete(key: PASSWORD);
    } catch (_) {
      throw ClearAccountInfoException();
    }
  }

  @override
  Future<void> saveUserInfo(UserInfo userInfo) async {
    // Saves user information in the Hive database under a specific box and key.
    try {
      final userInfoBox = await hiveCollections.openBox<Map>(USER_INFO_BOX);
      await userInfoBox.put(
        USER_INFO_KEY,
        userInfo.toMap(),
      );
    } catch (_) {
      throw SaveUserInfoException();
    }
  }

  @override
  Future<UserInfo?> getUserInfo() async {
    // Retrieves user information from the Hive database.
    try {
      final userInfoBox = await hiveCollections.openBox<Map<String, dynamic>>(USER_INFO_BOX);

      final userInfoMap = await userInfoBox.get(USER_INFO_KEY);
      if (userInfoMap != null) {
        final userInfo = UserInfoModel.fromJson(userInfoMap);
        return userInfo;
      }
      return null;
    } catch (_) {
      throw GetUserInfoException();
    }
  }

  @override
  Future<void> clearUserInfo() async {
    // Deletes user information from the Hive database.
    try {
      final userInfoBox = await hiveCollections.openBox<Map<String, dynamic>>(USER_INFO_BOX);

      await userInfoBox.delete(USER_INFO_KEY);
    } catch (_) {
      throw ClearUserInfoException();
    }
  }
}
