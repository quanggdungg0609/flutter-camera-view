import 'package:equatable/equatable.dart';

abstract class AccountInfo extends Equatable {
  final String accountID;
  final String password;

  const AccountInfo({required this.accountID, required this.password});

  @override
  List<Object?> get props => [accountID, password];
}
