// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_register.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRegister _$UserRegisterFromJson(Map<String, dynamic> json) => UserRegister(
      json['name'] as String,
      json['surname'] as String,
      json['email'] as String,
      json['phone'] as String,
      json['username'] as String,
      json['gender'] as String,
      json['address'] as String,
      json['postalCode'] as String,
      json['password'] as String,
      json['passwordConfirm'] as String,
      json['image'] as String?,
      json['city'] as String,
      (json['workDays'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      json['openingTime'] as String,
      json['closingTime'] as String,
    );

Map<String, dynamic> _$UserRegisterToJson(UserRegister instance) =>
    <String, dynamic>{
      'name': instance.name,
      'surname': instance.surname,
      'email': instance.email,
      'phone': instance.phone,
      'username': instance.username,
      'gender': instance.gender,
      'address': instance.address,
      'postalCode': instance.postalCode,
      'password': instance.password,
      'passwordConfirm': instance.passwordConfirm,
      'image': instance.image,
      'city': instance.city,
      'workDays': instance.workDays,
      'openingTime': instance.openingTime,
      'closingTime': instance.closingTime,
    };
