// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_item_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreItemCategory _$StoreItemCategoryFromJson(Map<String, dynamic> json) =>
    StoreItemCategory(
      (json['id'] as num).toInt(),
      json['name'] as String,
    );

Map<String, dynamic> _$StoreItemCategoryToJson(StoreItemCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
