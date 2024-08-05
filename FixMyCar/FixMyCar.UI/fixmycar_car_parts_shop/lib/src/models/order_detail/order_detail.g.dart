// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetail _$OrderDetailFromJson(Map<String, dynamic> json) => OrderDetail(
      (json['id'] as num).toInt(),
      (json['orderId'] as num).toInt(),
      (json['storeItemId'] as num).toInt(),
      json['storeItemName'] as String,
      (json['quantity'] as num).toInt(),
      (json['unitPrice'] as num).toDouble(),
      (json['totalItemsPrice'] as num).toDouble(),
      (json['totalItemsPriceDiscounted'] as num).toDouble(),
      (json['discount'] as num).toDouble(),
    );

Map<String, dynamic> _$OrderDetailToJson(OrderDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'storeItemId': instance.storeItemId,
      'storeItemName': instance.storeItemName,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'totalItemsPrice': instance.totalItemsPrice,
      'totalItemsPriceDiscounted': instance.totalItemsPriceDiscounted,
      'discount': instance.discount,
    };
