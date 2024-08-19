// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_repair_shop_service_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarRepairShopServiceSearchObject _$CarRepairShopServiceSearchObjectFromJson(
        Map<String, dynamic> json) =>
    CarRepairShopServiceSearchObject(
      json['serviceType'] as String?,
      json['name'] as String?,
      json['withDiscount'] as bool?,
      json['state'] as String?,
    );

Map<String, dynamic> _$CarRepairShopServiceSearchObjectToJson(
        CarRepairShopServiceSearchObject instance) =>
    <String, dynamic>{
      'serviceType': instance.serviceType,
      'name': instance.name,
      'withDiscount': instance.withDiscount,
      'state': instance.state,
    };
