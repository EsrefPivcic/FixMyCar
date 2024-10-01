// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      (json['id'] as num).toInt(),
      json['carPartsShopName'] as String,
      json['username'] as String,
      json['orderDate'] as String,
      json['shippingDate'] as String?,
      (json['totalAmount'] as num).toDouble(),
      (json['clientDiscountValue'] as num).toDouble(),
      json['state'] as String,
      json['shippingCity'] as String,
      json['shippingAddress'] as String,
      json['shippingPostalCode'] as String,
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'carPartsShopName': instance.carPartsShopName,
      'username': instance.username,
      'orderDate': instance.orderDate,
      'shippingDate': instance.shippingDate,
      'totalAmount': instance.totalAmount,
      'clientDiscountValue': instance.clientDiscountValue,
      'state': instance.state,
      'shippingCity': instance.shippingCity,
      'shippingAddress': instance.shippingAddress,
      'shippingPostalCode': instance.shippingPostalCode,
    };
