import 'package:json_annotation/json_annotation.dart';

part 'user_update_password.g.dart';

@JsonSerializable()
class UserUpdatePassword {
  String oldPassword;
  String newPassword;
  String confirmNewPassword;

  UserUpdatePassword(this.oldPassword, this.newPassword, this.confirmNewPassword);

  factory UserUpdatePassword.fromJson(Map<String, dynamic> json) =>
      _$UserUpdatePasswordFromJson(json);

  Map<String, dynamic> toJson() => _$UserUpdatePasswordToJson(this);
}