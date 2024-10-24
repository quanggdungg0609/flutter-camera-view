part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthState {}

class FetchingAccountInfoState extends AuthState {}

// ignore: must_be_immutable
class NotConnectedState extends AuthState {
  AccountInfo? accountInfo;
  NotConnectedState(this.accountInfo);

  @override
  List<Object?> get props => [accountInfo];
}

class Connecting extends AuthState {}

class Connected extends AuthState {}
