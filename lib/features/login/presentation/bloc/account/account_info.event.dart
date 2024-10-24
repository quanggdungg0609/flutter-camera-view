part of 'account_info.bloc.dart';

abstract class AccountInfoEvent extends Equatable {
  const AccountInfoEvent();

  @override
  List<Object?> get props => [];
}

class FetchAccountInfoEvent extends AccountInfoEvent {}

class SaveAccountInfoEvent extends AccountInfoEvent {
  final String accountID;
  final String password;

  const SaveAccountInfoEvent({required this.accountID, required this.password});

  @override
  List<Object?> get props => [accountID, password];
}

class ClearAccountInfoEvent extends AccountInfoEvent {}
