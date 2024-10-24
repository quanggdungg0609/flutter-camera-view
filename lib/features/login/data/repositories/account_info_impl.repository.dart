import 'package:dartz/dartz.dart';
import 'package:flutter_camera_view/core/exceptions/local_datasource.exception.dart';
import 'package:flutter_camera_view/core/failures/account_info.dart';
import 'package:flutter_camera_view/core/failures/failure.dart';
import 'package:flutter_camera_view/features/login/data/datasources/local.datasource.dart';
import 'package:flutter_camera_view/features/login/data/models/account_info.model.dart';
import 'package:flutter_camera_view/features/login/domain/entities/account_info.entity.dart';
import 'package:flutter_camera_view/features/login/domain/repositories/account_info.repository.dart';

class AccountInfoImplRepository implements AccountInfoRepository {
  final LocalDataSource localDataSource;

  AccountInfoImplRepository({required this.localDataSource});

  @override
  Future<Either<Failure, Unit>> saveAccountInfo(String account, String password) async {
    try {
      AccountInfoModel accountInfo = AccountInfoModel(accountID: account, password: password);
      await localDataSource.saveAccountInfo(accountInfo);
      return const Right(unit);
    } on SaveAccountInfoException {
      return Left(SaveAccountInfoFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> clearAccountInfo() async {
    try {
      await localDataSource.clearAccountInfo();
      return const Right(unit);
    } on ClearAccountInfoException {
      return Left(ClearAccountInfoFailure());
    }
  }

  @override
  Future<Either<Failure, AccountInfo?>> fetchAccountInfo() async {
    try {
      AccountInfo? accountInfo = await localDataSource.getAccountInfo();
      return Right(accountInfo);
    } on GetAccoutInfoException {
      return Left(FetchAccountInfoFailure());
    }
  }
}
