// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_item_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreItemOrder _$StoreItemOrderFromJson(Map<String, dynamic> json) =>
    StoreItemOrder(
      (json['storeItemId'] as num).toInt(),
      (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$StoreItemOrderToJson(StoreItemOrder instance) =>
    <String, dynamic>{
      'storeItemId': instance.storeItemId,
      'quantity': instance.quantity,
    };
