// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_minimal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMinimal _$UserMinimalFromJson(Map<String, dynamic> json) => UserMinimal(
      (json['id'] as num).toInt(),
      json['username'] as String,
      json['name'] as String,
      json['surname'] as String,
      json['image'] as String?,
    );

Map<String, dynamic> _$UserMinimalToJson(UserMinimal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'name': instance.name,
      'surname': instance.surname,
      'image': instance.image,
    };
