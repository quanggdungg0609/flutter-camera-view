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
      userName: json["user"]["username"],
      email: json["user"]["email"],
      role: json["user"]["role"],
      firstName: json["user"]["first_name"] as String?,
      lastName: json["user"]["last_name"] as String?,
    );
  }
}
