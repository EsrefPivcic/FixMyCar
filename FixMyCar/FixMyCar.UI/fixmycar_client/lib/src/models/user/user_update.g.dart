// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserUpdate _$UserUpdateFromJson(Map<String, dynamic> json) => UserUpdate(
      json['name'] as String?,
      json['surname'] as String?,
      json['email'] as String?,
      json['phone'] as String?,
      json['gender'] as String?,
      json['address'] as String?,
      json['postalCode'] as String?,
      json['city'] as String?,
    );

Map<String, dynamic> _$UserUpdateToJson(UserUpdate instance) =>
    <String, dynamic>{
      'name': instance.name,
      'surname': instance.surname,
      'email': instance.email,
      'phone': instance.phone,
      'gender': instance.gender,
      'address': instance.address,
      'postalCode': instance.postalCode,
      'city': instance.city,
    };
