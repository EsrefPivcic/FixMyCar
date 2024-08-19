// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_repair_shop_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarRepairShopService _$CarRepairShopServiceFromJson(
        Map<String, dynamic> json) =>
    CarRepairShopService(
      (json['id'] as num).toInt(),
      (json['serviceTypeId'] as num).toInt(),
      json['serviceTypeName'] as String,
      json['name'] as String,
      (json['price'] as num).toDouble(),
      (json['discount'] as num).toDouble(),
      (json['discountedPrice'] as num).toDouble(),
      json['state'] as String,
      json['imageData'] as String?,
      json['details'] as String?,
      json['duration'] as String,
    );

Map<String, dynamic> _$CarRepairShopServiceToJson(
        CarRepairShopService instance) =>
    <String, dynamic>{
      'id': instance.id,
      'serviceTypeId': instance.serviceTypeId,
      'serviceTypeName': instance.serviceTypeName,
      'name': instance.name,
      'price': instance.price,
      'discount': instance.discount,
      'discountedPrice': instance.discountedPrice,
      'state': instance.state,
      'imageData': instance.imageData,
      'details': instance.details,
      'duration': instance.duration,
    };
