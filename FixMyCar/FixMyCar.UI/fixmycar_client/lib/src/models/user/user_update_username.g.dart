// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_update_username.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserUpdateUsername _$UserUpdateUsernameFromJson(Map<String, dynamic> json) =>
    UserUpdateUsername(
      json['newUsername'] as String,
      json['password'] as String,
    );

Map<String, dynamic> _$UserUpdateUsernameToJson(UserUpdateUsername instance) =>
    <String, dynamic>{
      'newUsername': instance.newUsername,
      'password': instance.password,
    };
