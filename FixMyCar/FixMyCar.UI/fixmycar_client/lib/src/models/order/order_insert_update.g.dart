// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_insert_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderInsertUpdate _$OrderInsertUpdateFromJson(Map<String, dynamic> json) =>
    OrderInsertUpdate(
      (json['carPartsShopId'] as num?)?.toInt(),
      json['userAddress'] as bool?,
      json['shippingCity'] as String?,
      json['shippingAddress'] as String?,
      json['shippingPostalCode'] as String?,
      json['paymentMethod'] as String?,
      (json['storeItems'] as List<dynamic>?)
          ?.map((e) => StoreItemOrder.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderInsertUpdateToJson(OrderInsertUpdate instance) =>
    <String, dynamic>{
      'carPartsShopId': instance.carPartsShopId,
      'userAddress': instance.userAddress,
      'shippingCity': instance.shippingCity,
      'shippingAddress': instance.shippingAddress,
      'shippingPostalCode': instance.shippingPostalCode,
      'paymentMethod': instance.paymentMethod,
      'storeItems': instance.storeItems,
    };
