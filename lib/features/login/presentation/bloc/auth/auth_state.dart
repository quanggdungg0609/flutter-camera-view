part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

// ignore: must_be_immutable
class NotConnectedState extends AuthState {}

class Connecting extends AuthState {}

class Connected extends AuthState {}
