import 'package:json_annotation/json_annotation.dart';

part 'car_repair_shop_discount.g.dart';

@JsonSerializable()
class CarRepairShopDiscount {
  int id;
  String client;
  String carRepairShop;
  double value;
  String created;
  String? revoked;

  CarRepairShopDiscount(this.id, this.client, this.carRepairShop, this.value,
      this.created, this.revoked);

  factory CarRepairShopDiscount.fromJson(Map<String, dynamic> json) =>
      _$CarRepairShopDiscountFromJson(json);

  Map<String, dynamic> toJson() => _$CarRepairShopDiscountToJson(this);
}
