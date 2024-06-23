// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreItem _$StoreItemFromJson(Map<String, dynamic> json) => StoreItem(
      json['name'] as String?,
      json['state'] as String,
      (json['discount'] as num).toDouble(),
      json['imageData'] as String?,
      json['imageMimeType'] as String?,
    );

Map<String, dynamic> _$StoreItemToJson(StoreItem instance) => <String, dynamic>{
      'name': instance.name,
      'state': instance.state,
      'discount': instance.discount,
      'imageData': instance.imageData,
      'imageMimeType': instance.imageMimeType,
    };
