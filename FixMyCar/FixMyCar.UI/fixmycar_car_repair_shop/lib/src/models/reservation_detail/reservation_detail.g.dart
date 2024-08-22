// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationDetail _$ReservationDetailFromJson(Map<String, dynamic> json) =>
    ReservationDetail(
      (json['carRepairShopServiceId'] as num).toInt(),
      json['serviceName'] as String,
      (json['servicePrice'] as num).toDouble(),
      (json['serviceDiscount'] as num).toDouble(),
      (json['serviceDiscountedPrice'] as num).toDouble(),
    );

Map<String, dynamic> _$ReservationDetailToJson(ReservationDetail instance) =>
    <String, dynamic>{
      'carRepairShopServiceId': instance.carRepairShopServiceId,
      'serviceName': instance.serviceName,
      'servicePrice': instance.servicePrice,
      'serviceDiscount': instance.serviceDiscount,
      'serviceDiscountedPrice': instance.serviceDiscountedPrice,
    };
