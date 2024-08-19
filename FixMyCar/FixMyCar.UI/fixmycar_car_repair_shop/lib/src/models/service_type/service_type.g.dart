// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceType _$ServiceTypeFromJson(Map<String, dynamic> json) => ServiceType(
      (json['id'] as num).toInt(),
      json['name'] as String,
      json['image'] as String,
    );

Map<String, dynamic> _$ServiceTypeToJson(ServiceType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
    };
