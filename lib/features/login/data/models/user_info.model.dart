import 'package:flutter_camera_view/features/login/domain/entities/user_info.entity.dart';

class UserInfoModel extends UserInfo {
  const UserInfoModel({
    required super.userName,
    required super.email,
    required super.role,
    super.firstName,
    super.lastName,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      userName: json["username"],
      email: json["email"],
      role: json["role"],
      firstName: json["first_name"],
      lastName: json["last_name"],
    );
  }
}
