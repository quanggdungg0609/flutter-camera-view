import 'package:dartz/dartz.dart';
import 'package:flutter_camera_view/core/exceptions/auth_datasource.exception.dart';
import 'package:flutter_camera_view/core/failures/auth.failure.dart';
import 'package:flutter_camera_view/features/login/data/datasources/auth.datasource.dart';
import 'package:flutter_camera_view/features/login/data/datasources/local.datasource.dart';
import 'package:flutter_camera_view/features/login/data/models/account_info.model.dart';
import 'package:flutter_camera_view/features/login/domain/entities/login_response.entity.dart';
import 'package:flutter_camera_view/features/login/domain/entities/user_info.entity.dart';
import 'package:flutter_camera_view/features/login/domain/repositories/auth.repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource authDataSource;
  final LocalDataSource localDataSource;

  AuthRepositoryImpl({required this.authDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, UserInfo>> login(String account, String password) async {
    try {
      AccountInfoModel accountInfo = AccountInfoModel(accountID: account, password: password);
      LoginResponse loginResponse = await authDataSource.login(accountInfo);

      // save access token and refresh token into localDatasource
      await localDataSource.saveToken(loginResponse.accessToken, loginResponse.refreshToken);
      // save user Info into localDataSource
      await localDataSource.saveUserInfo(loginResponse.userInfo);

      return Right(loginResponse.userInfo);
    } on FailedToLoginException {
      return Left(LoginFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> saveAccountInfo(String account, String password) {
    // TODO: implement saveAccountInfo
    throw UnimplementedError();
  }
}
