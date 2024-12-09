// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_insert_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderInsertUpdate _$OrderInsertUpdateFromJson(Map<String, dynamic> json) =>
    OrderInsertUpdate(
      (json['carPartsShopId'] as num?)?.toInt(),
      json['userAddress'] as bool?,
      (json['cityId'] as num?)?.toInt(),
      json['shippingAddress'] as String?,
      json['shippingPostalCode'] as String?,
      (json['storeItems'] as List<dynamic>?)
          ?.map((e) => StoreItemOrder.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderInsertUpdateToJson(OrderInsertUpdate instance) =>
    <String, dynamic>{
      'carPartsShopId': instance.carPartsShopId,
      'userAddress': instance.userAddress,
      'cityId': instance.cityId,
      'shippingAddress': instance.shippingAddress,
      'shippingPostalCode': instance.shippingPostalCode,
      'storeItems': instance.storeItems,
    };
