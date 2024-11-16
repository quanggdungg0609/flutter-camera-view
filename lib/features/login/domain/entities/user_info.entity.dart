import 'package:equatable/equatable.dart';

abstract class UserInfo extends Equatable {
  final String userName;
  final String email;
  final String role;
  final String? firstName;
  final String? lastName;

  const UserInfo({
    required this.userName,
    required this.email,
    required this.role,
    this.firstName,
    this.lastName,
  });

  @override
  List<Object?> get props => [
        userName,
        email,
        role,
        firstName,
        lastName,
      ];

  Map<String, dynamic> toMap() {
    return {
      "userName": userName,
      "email": email,
      "role": role,
      "firstName": firstName,
      "lastName": lastName,
    };
  }
}
