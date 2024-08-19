// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_repair_shop_discount_insert_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarRepairShopDiscountInsertUpdate _$CarRepairShopDiscountInsertUpdateFromJson(
        Map<String, dynamic> json) =>
    CarRepairShopDiscountInsertUpdate(
      json['username'] as String?,
      (json['value'] as num?)?.toDouble(),
      json['revoked'] as bool?,
    );

Map<String, dynamic> _$CarRepairShopDiscountInsertUpdateToJson(
        CarRepairShopDiscountInsertUpdate instance) =>
    <String, dynamic>{
      'username': instance.username,
      'value': instance.value,
      'revoked': instance.revoked,
    };
