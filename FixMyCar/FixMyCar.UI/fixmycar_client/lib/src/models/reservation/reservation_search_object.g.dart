// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationSearchObject _$ReservationSearchObjectFromJson(
        Map<String, dynamic> json) =>
    ReservationSearchObject(
      json['discount'] as bool?,
      json['state'] as String?,
      json['type'] as String?,
      (json['minTotalAmount'] as num?)?.toDouble(),
      (json['maxTotalAmount'] as num?)?.toDouble(),
      json['clientOrder'] as bool?,
      json['minCreatedDate'] == null
          ? null
          : DateTime.parse(json['minCreatedDate'] as String),
      json['maxCreatedDate'] == null
          ? null
          : DateTime.parse(json['maxCreatedDate'] as String),
      json['minReservationDate'] == null
          ? null
          : DateTime.parse(json['minReservationDate'] as String),
      json['maxReservationDate'] == null
          ? null
          : DateTime.parse(json['maxReservationDate'] as String),
      json['minEstimatedCompletionDate'] == null
          ? null
          : DateTime.parse(json['minEstimatedCompletionDate'] as String),
      json['maxEstimatedCompletionDate'] == null
          ? null
          : DateTime.parse(json['maxEstimatedCompletionDate'] as String),
      json['minCompletionDate'] == null
          ? null
          : DateTime.parse(json['minCompletionDate'] as String),
      json['maxCompletionDate'] == null
          ? null
          : DateTime.parse(json['maxCompletionDate'] as String),
    );

Map<String, dynamic> _$ReservationSearchObjectToJson(
        ReservationSearchObject instance) =>
    <String, dynamic>{
      'discount': instance.discount,
      'state': instance.state,
      'type': instance.type,
      'minTotalAmount': instance.minTotalAmount,
      'maxTotalAmount': instance.maxTotalAmount,
      'clientOrder': instance.clientOrder,
      'minCreatedDate': instance.minCreatedDate?.toIso8601String(),
      'maxCreatedDate': instance.maxCreatedDate?.toIso8601String(),
      'minReservationDate': instance.minReservationDate?.toIso8601String(),
      'maxReservationDate': instance.maxReservationDate?.toIso8601String(),
      'minEstimatedCompletionDate':
          instance.minEstimatedCompletionDate?.toIso8601String(),
      'maxEstimatedCompletionDate':
          instance.maxEstimatedCompletionDate?.toIso8601String(),
      'minCompletionDate': instance.minCompletionDate?.toIso8601String(),
      'maxCompletionDate': instance.maxCompletionDate?.toIso8601String(),
    };
