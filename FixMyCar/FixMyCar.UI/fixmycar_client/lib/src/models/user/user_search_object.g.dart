// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSearchObject _$UserSearchObjectFromJson(Map<String, dynamic> json) =>
    UserSearchObject(
      json['containsUsername'] as String?,
      json['active'] as bool?,
      json['role'] as String?,
    );

Map<String, dynamic> _$UserSearchObjectToJson(UserSearchObject instance) =>
    <String, dynamic>{
      'containsUsername': instance.containsUsername,
      'active': instance.active,
      'role': instance.role,
    };
