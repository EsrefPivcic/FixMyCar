// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarModel _$CarModelFromJson(Map<String, dynamic> json) => CarModel(
      (json['id'] as num).toInt(),
      json['manufacturer'] as String?,
      json['name'] as String,
      json['modelYear'] as String,
    );

Map<String, dynamic> _$CarModelToJson(CarModel instance) => <String, dynamic>{
      'id': instance.id,
      'manufacturer': instance.manufacturer,
      'name': instance.name,
      'modelYear': instance.modelYear,
    };
