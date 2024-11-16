part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

// ignore: must_be_immutable
class NoAuthenticatedState extends AuthState {}

class Authenticating extends AuthState {}

class Authenticated extends AuthState {}
