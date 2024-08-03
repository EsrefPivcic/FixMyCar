// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_parts_shop_client_discount_insert_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarPartsShopClientDiscountInsertUpdate
    _$CarPartsShopClientDiscountInsertUpdateFromJson(
            Map<String, dynamic> json) =>
        CarPartsShopClientDiscountInsertUpdate(
          json['username'] as String?,
          (json['value'] as num?)?.toDouble(),
          json['revoked'] as bool?,
        );

Map<String, dynamic> _$CarPartsShopClientDiscountInsertUpdateToJson(
        CarPartsShopClientDiscountInsertUpdate instance) =>
    <String, dynamic>{
      'username': instance.username,
      'value': instance.value,
      'revoked': instance.revoked,
    };
