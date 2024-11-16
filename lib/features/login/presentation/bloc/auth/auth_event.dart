part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String accountID;
  final String password;

  LoginEvent(this.accountID, this.password);

  @override
  List<Object?> get props => [accountID, password];
}
