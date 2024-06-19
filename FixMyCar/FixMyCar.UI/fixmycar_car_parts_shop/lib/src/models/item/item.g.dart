// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      json['name'] as String?,
      json['state'] as String,
      json['discount'] == null
          ? null
          : Discount.fromJson(json['discount'] as Map<String, dynamic>),
      json['imageData'] as String?,
      json['imageMimeType'] as String?,
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'name': instance.name,
      'state': instance.state,
      'discount': instance.discount,
      'imageData': instance.imageData,
      'imageMimeType': instance.imageMimeType,
    };
