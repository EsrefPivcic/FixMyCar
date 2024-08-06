// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_accept.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderAccept _$OrderAcceptFromJson(Map<String, dynamic> json) => OrderAccept(
      DateTime.parse(json['shippingDate'] as String),
    );

Map<String, dynamic> _$OrderAcceptToJson(OrderAccept instance) =>
    <String, dynamic>{
      'shippingDate': instance.shippingDate.toIso8601String(),
    };
