import 'package:equatable/equatable.dart';

abstract class AccessToken extends Equatable {
  final String _value;
  const AccessToken({required String value}) : _value = value;

  String get value => _value;

  @override
  List<Object?> get props => [_value];
}

abstract class RefreshToken extends Equatable {
  final String _value;
  const RefreshToken({required String value}) : _value = value;

  String get value => _value;

  @override
  List<Object?> get props => [_value];
}
