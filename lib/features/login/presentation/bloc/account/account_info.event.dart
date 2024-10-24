part of 'account_info.bloc.dart';

abstract class AccountInfoEvent extends Equatable {
  const AccountInfoEvent();

  @override
  List<Object?> get props => [];
}

class FetchAccountInfoEvent extends AccountInfoEvent {}
