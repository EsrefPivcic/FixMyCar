// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['name'] as String,
      json['surname'] as String,
      json['email'] as String,
      json['phone'] as String,
      json['username'] as String,
      json['created'] as String,
      json['gender'] as String,
      json['address'] as String,
      json['postalCode'] as String,
      json['image'] as String?,
      json['role'] as String,
      (json['cityId'] as num).toInt(),
      json['city'] as String,
      (json['workDays'] as List<dynamic>).map((e) => e as String).toList(),
      json['openingTime'] as String,
      json['closingTime'] as String,
      json['workingHours'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'name': instance.name,
      'surname': instance.surname,
      'email': instance.email,
      'phone': instance.phone,
      'username': instance.username,
      'created': instance.created,
      'gender': instance.gender,
      'address': instance.address,
      'postalCode': instance.postalCode,
      'image': instance.image,
      'role': instance.role,
      'cityId': instance.cityId,
      'city': instance.city,
      'workDays': instance.workDays,
      'openingTime': instance.openingTime,
      'closingTime': instance.closingTime,
      'workingHours': instance.workingHours,
    };
