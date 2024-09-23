import 'package:json_annotation/json_annotation.dart';

part 'car_repair_shop_service.g.dart';

@JsonSerializable()
class CarRepairShopService {
  int id;
  int serviceTypeId;
  String serviceTypeName;
  String name;
  double price;
  double discount;
  double discountedPrice;
  String state;
  String? imageData;
  String? details;
  String duration;

  CarRepairShopService(
      this.id,
      this.serviceTypeId,
      this.serviceTypeName,
      this.name,
      this.price,
      this.discount,
      this.discountedPrice,
      this.state,
      this.imageData,
      this.details,
      this.duration);

  factory CarRepairShopService.fromJson(Map<String, dynamic> json) =>
      _$CarRepairShopServiceFromJson(json);

  Map<String, dynamic> toJson() => _$CarRepairShopServiceToJson(this);
}
