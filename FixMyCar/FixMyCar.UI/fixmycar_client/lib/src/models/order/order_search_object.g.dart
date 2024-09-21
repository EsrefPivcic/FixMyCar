// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderSearchObject _$OrderSearchObjectFromJson(Map<String, dynamic> json) =>
    OrderSearchObject(
      json['discount'] as bool?,
      json['state'] as String?,
      (json['minTotalAmount'] as num?)?.toDouble(),
      (json['maxTotalAmount'] as num?)?.toDouble(),
      json['minOrderDate'] == null
          ? null
          : DateTime.parse(json['minOrderDate'] as String),
      json['maxOrderDate'] == null
          ? null
          : DateTime.parse(json['maxOrderDate'] as String),
      json['minShippingDate'] == null
          ? null
          : DateTime.parse(json['minShippingDate'] as String),
      json['maxShippingDate'] == null
          ? null
          : DateTime.parse(json['maxShippingDate'] as String),
    );

Map<String, dynamic> _$OrderSearchObjectToJson(OrderSearchObject instance) =>
    <String, dynamic>{
      'discount': instance.discount,
      'state': instance.state,
      'minTotalAmount': instance.minTotalAmount,
      'maxTotalAmount': instance.maxTotalAmount,
      'minOrderDate': instance.minOrderDate?.toIso8601String(),
      'maxOrderDate': instance.maxOrderDate?.toIso8601String(),
      'minShippingDate': instance.minShippingDate?.toIso8601String(),
      'maxShippingDate': instance.maxShippingDate?.toIso8601String(),
    };
