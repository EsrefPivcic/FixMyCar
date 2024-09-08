// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reservation _$ReservationFromJson(Map<String, dynamic> json) => Reservation(
      (json['id'] as num).toInt(),
      json['carRepairShopName'] as String,
      json['clientUsername'] as String,
      (json['orderId'] as num?)?.toInt(),
      json['clientOrder'] as bool?,
      json['reservationCreatedDate'] as String,
      json['reservationDate'] as String,
      json['estimatedCompletionDate'] as String?,
      json['completionDate'] as String?,
      (json['totalAmount'] as num).toDouble(),
      json['totalDuration'] as String,
      (json['carRepairShopDiscountValue'] as num).toDouble(),
      json['state'] as String,
      json['type'] as String,
      json['paymentMethod'] as String,
    );

Map<String, dynamic> _$ReservationToJson(Reservation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'carRepairShopName': instance.carRepairShopName,
      'clientUsername': instance.clientUsername,
      'orderId': instance.orderId,
      'clientOrder': instance.clientOrder,
      'reservationCreatedDate': instance.reservationCreatedDate,
      'reservationDate': instance.reservationDate,
      'estimatedCompletionDate': instance.estimatedCompletionDate,
      'completionDate': instance.completionDate,
      'totalAmount': instance.totalAmount,
      'totalDuration': instance.totalDuration,
      'carRepairShopDiscountValue': instance.carRepairShopDiscountValue,
      'state': instance.state,
      'type': instance.type,
      'paymentMethod': instance.paymentMethod,
    };
