// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_insert_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationInsertUpdate _$ReservationInsertUpdateFromJson(
        Map<String, dynamic> json) =>
    ReservationInsertUpdate(
      (json['carRepairShopId'] as num?)?.toInt(),
      (json['orderId'] as num?)?.toInt(),
      json['clientOrder'] as bool?,
      json['reservationDate'] == null
          ? null
          : DateTime.parse(json['reservationDate'] as String),
      json['paymentMethod'] as String?,
      (json['services'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$ReservationInsertUpdateToJson(
        ReservationInsertUpdate instance) =>
    <String, dynamic>{
      'carRepairShopId': instance.carRepairShopId,
      'orderId': instance.orderId,
      'clientOrder': instance.clientOrder,
      'reservationDate': instance.reservationDate?.toIso8601String(),
      'paymentMethod': instance.paymentMethod,
      'services': instance.services,
    };
