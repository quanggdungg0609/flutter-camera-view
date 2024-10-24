part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchAccountInfoEvent extends AuthEvent {}

class SaveAccountInfoEvent extends AuthEvent {
  final String accountID;
  final String password;

  SaveAccountInfoEvent(this.accountID, this.password);

  @override
  List<Object?> get props => [accountID, password];
}

class LoginEvent extends AuthEvent {
  final String accountID;
  final String password;

  LoginEvent(this.accountID, this.password);

  @override
  List<Object?> get props => [accountID, password];
}

class ClearAccountInfoEvent extends AuthEvent {}
