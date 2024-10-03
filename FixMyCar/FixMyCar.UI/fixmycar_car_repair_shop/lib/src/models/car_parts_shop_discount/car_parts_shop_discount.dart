import 'package:json_annotation/json_annotation.dart';

part 'car_parts_shop_discount.g.dart';

@JsonSerializable()
class CarPartsShopDiscount {
  int id;
  String carPartsShop;
  String user;
  String role;
  double value;
  String created;
  String? revoked;

  CarPartsShopDiscount(this.id, this.carPartsShop, this.user, this.role,
      this.value, this.created, this.revoked);

  factory CarPartsShopDiscount.fromJson(Map<String, dynamic> json) =>
      _$CarPartsShopDiscountFromJson(json);

  Map<String, dynamic> toJson() => _$CarPartsShopDiscountToJson(this);
}
