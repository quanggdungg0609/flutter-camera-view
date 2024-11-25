part of 'account_info.bloc.dart';

abstract class AccountInfoState extends Equatable {
  const AccountInfoState();

  @override
  List<Object?> get props => [];
}

class AccountInfoInitialState extends AccountInfoState {}

class FetchingAccountInfoState extends AccountInfoState {}

class SavingAccountInfoState extends AccountInfoState {}

// ignore: must_be_immutable
class AccountInfoNormalState extends AccountInfoState {
  AccountInfo? accountInfo;
  AccountInfoNormalState(this.accountInfo);

  @override
  List<Object?> get props => [accountInfo];
}
