// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_repair_shop_discount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarRepairShopDiscount _$CarRepairShopDiscountFromJson(
        Map<String, dynamic> json) =>
    CarRepairShopDiscount(
      (json['id'] as num).toInt(),
      json['client'] as String,
      (json['value'] as num).toDouble(),
      json['created'] as String,
      json['revoked'] as String?,
    );

Map<String, dynamic> _$CarRepairShopDiscountToJson(
        CarRepairShopDiscount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'client': instance.client,
      'value': instance.value,
      'created': instance.created,
      'revoked': instance.revoked,
    };
