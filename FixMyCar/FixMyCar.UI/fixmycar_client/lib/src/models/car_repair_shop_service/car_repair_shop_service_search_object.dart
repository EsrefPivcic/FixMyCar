import 'package:json_annotation/json_annotation.dart';

part 'car_repair_shop_service_search_object.g.dart';

@JsonSerializable()
class CarRepairShopServiceSearchObject {
  String? serviceType;
  String? name;
  bool? withDiscount;

  CarRepairShopServiceSearchObject(
      this.serviceType,
      this.name,
      this.withDiscount);

  factory CarRepairShopServiceSearchObject.fromJson(Map<String, dynamic> json) =>
      _$CarRepairShopServiceSearchObjectFromJson(json);

  Map<String, dynamic> toJson() => _$CarRepairShopServiceSearchObjectToJson(this);
}
