// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreItem _$StoreItemFromJson(Map<String, dynamic> json) => StoreItem(
      (json['id'] as num).toInt(),
      json['name'] as String,
      (json['price'] as num).toDouble(),
      json['state'] as String,
      (json['discount'] as num).toDouble(),
      (json['discountedPrice'] as num).toDouble(),
      json['imageData'] as String?,
      json['details'] as String?,
      (json['carModels'] as List<dynamic>?)
          ?.map((e) => CarModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['storeItemCategoryId'] as num?)?.toInt(),
      json['category'] as String?,
    );

Map<String, dynamic> _$StoreItemToJson(StoreItem instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'state': instance.state,
      'discount': instance.discount,
      'discountedPrice': instance.discountedPrice,
      'imageData': instance.imageData,
      'details': instance.details,
      'carModels': instance.carModels,
      'storeItemCategoryId': instance.storeItemCategoryId,
      'category': instance.category,
    };
