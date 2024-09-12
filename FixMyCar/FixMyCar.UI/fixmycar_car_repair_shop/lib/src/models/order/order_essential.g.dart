// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_essential.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderEssential _$OrderEssentialFromJson(Map<String, dynamic> json) =>
    OrderEssential(
      json['carPartsShopName'] as String,
      json['username'] as String,
      json['orderDate'] as String,
      json['shippingDate'] as String?,
      json['state'] as String,
      (json['items'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$OrderEssentialToJson(OrderEssential instance) =>
    <String, dynamic>{
      'carPartsShopName': instance.carPartsShopName,
      'username': instance.username,
      'orderDate': instance.orderDate,
      'shippingDate': instance.shippingDate,
      'state': instance.state,
      'items': instance.items,
    };
