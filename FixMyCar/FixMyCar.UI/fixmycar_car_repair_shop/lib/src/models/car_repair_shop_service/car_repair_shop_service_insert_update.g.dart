// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_repair_shop_service_insert_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarRepairShopServiceInsertUpdate _$CarRepairShopServiceInsertUpdateFromJson(
        Map<String, dynamic> json) =>
    CarRepairShopServiceInsertUpdate(
      (json['serviceTypeId'] as num?)?.toInt(),
      json['name'] as String?,
      (json['price'] as num?)?.toDouble(),
      (json['discount'] as num?)?.toDouble(),
      json['imageData'] as String?,
      json['details'] as String?,
      json['duration'] as String?,
    );

Map<String, dynamic> _$CarRepairShopServiceInsertUpdateToJson(
        CarRepairShopServiceInsertUpdate instance) =>
    <String, dynamic>{
      'serviceTypeId': instance.serviceTypeId,
      'name': instance.name,
      'price': instance.price,
      'discount': instance.discount,
      'imageData': instance.imageData,
      'details': instance.details,
      'duration': instance.duration,
    };
