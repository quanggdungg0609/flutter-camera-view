part of 'account_info.bloc.dart';

abstract class AccountInfoState extends Equatable {
  const AccountInfoState();

  @override
  List<Object?> get props => [];
}

class AccountInfoInitialState extends AccountInfoState {}

class FetchingAccountInfoState extends AccountInfoState {}

// ignore: must_be_immutable
class AccountInfoFetchedState extends AccountInfoState {
  AccountInfo? accountInfo;
  AccountInfoFetchedState(this.accountInfo);

  @override
  List<Object?> get props => [accountInfo];
}
