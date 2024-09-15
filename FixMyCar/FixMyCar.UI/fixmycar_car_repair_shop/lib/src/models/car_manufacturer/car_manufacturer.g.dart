// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_manufacturer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarManufacturer _$CarManufacturerFromJson(Map<String, dynamic> json) =>
    CarManufacturer(
      (json['id'] as num).toInt(),
      json['name'] as String,
    );

Map<String, dynamic> _$CarManufacturerToJson(CarManufacturer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
