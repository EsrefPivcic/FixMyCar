// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_item_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreItemUpdate _$StoreItemUpdateFromJson(Map<String, dynamic> json) =>
    StoreItemUpdate(
      json['name'] as String?,
      (json['price'] as num?)?.toDouble(),
      (json['discount'] as num?)?.toDouble(),
      json['imageData'] as String?,
      json['details'] as String?,
      (json['carModelIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      (json['storeItemCategoryId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StoreItemUpdateToJson(StoreItemUpdate instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'discount': instance.discount,
      'imageData': instance.imageData,
      'details': instance.details,
      'carModelIds': instance.carModelIds,
      'storeItemCategoryId': instance.storeItemCategoryId,
    };
