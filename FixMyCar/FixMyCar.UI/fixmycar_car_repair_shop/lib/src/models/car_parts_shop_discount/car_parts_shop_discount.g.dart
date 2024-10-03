// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_parts_shop_discount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarPartsShopDiscount _$CarPartsShopDiscountFromJson(
        Map<String, dynamic> json) =>
    CarPartsShopDiscount(
      (json['id'] as num).toInt(),
      json['carPartsShop'] as String,
      json['user'] as String,
      json['role'] as String,
      (json['value'] as num).toDouble(),
      json['created'] as String,
      json['revoked'] as String?,
    );

Map<String, dynamic> _$CarPartsShopDiscountToJson(
        CarPartsShopDiscount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'carPartsShop': instance.carPartsShop,
      'user': instance.user,
      'role': instance.role,
      'value': instance.value,
      'created': instance.created,
      'revoked': instance.revoked,
    };
