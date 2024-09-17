// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_update_password.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserUpdatePassword _$UserUpdatePasswordFromJson(Map<String, dynamic> json) =>
    UserUpdatePassword(
      json['oldPassword'] as String,
      json['newPassword'] as String,
      json['confirmNewPassword'] as String,
    );

Map<String, dynamic> _$UserUpdatePasswordToJson(UserUpdatePassword instance) =>
    <String, dynamic>{
      'oldPassword': instance.oldPassword,
      'newPassword': instance.newPassword,
      'confirmNewPassword': instance.confirmNewPassword,
    };
