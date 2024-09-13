// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_update_work_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserUpdateWorkDetails _$UserUpdateWorkDetailsFromJson(
        Map<String, dynamic> json) =>
    UserUpdateWorkDetails(
      (json['workDays'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      json['openingTime'] as String,
      json['closingTime'] as String,
    );

Map<String, dynamic> _$UserUpdateWorkDetailsToJson(
        UserUpdateWorkDetails instance) =>
    <String, dynamic>{
      'workDays': instance.workDays,
      'openingTime': instance.openingTime,
      'closingTime': instance.closingTime,
    };
