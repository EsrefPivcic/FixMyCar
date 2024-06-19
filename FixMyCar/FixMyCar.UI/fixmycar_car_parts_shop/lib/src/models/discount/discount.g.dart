// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Discount _$DiscountFromJson(Map<String, dynamic> json) => Discount(
      (json['id'] as num?)?.toInt(),
      (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$DiscountToJson(Discount instance) => <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
    };
