// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_parts_shop_client_discount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarPartsShopClientDiscount _$CarPartsShopClientDiscountFromJson(
        Map<String, dynamic> json) =>
    CarPartsShopClientDiscount(
      (json['id'] as num).toInt(),
      json['user'] as String,
      json['role'] as String,
      (json['value'] as num).toDouble(),
      json['created'] as String,
      json['revoked'] as String?,
    );

Map<String, dynamic> _$CarPartsShopClientDiscountToJson(
        CarPartsShopClientDiscount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'role': instance.role,
      'value': instance.value,
      'created': instance.created,
      'revoked': instance.revoked,
    };
