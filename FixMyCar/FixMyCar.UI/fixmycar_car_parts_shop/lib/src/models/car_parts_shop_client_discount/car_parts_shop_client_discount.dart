import 'package:json_annotation/json_annotation.dart';

part 'car_parts_shop_client_discount.g.dart';

@JsonSerializable()
class CarPartsShopClientDiscount {
  int id;
  String user;
  String role;
  double value;
  String created;
  String? revoked;

  CarPartsShopClientDiscount(
      this.id, this.user, this.role, this.value, this.created, this.revoked);

  factory CarPartsShopClientDiscount.fromJson(Map<String, dynamic> json) => _$CarPartsShopClientDiscountFromJson(json);

  Map<String, dynamic> toJson() => _$CarPartsShopClientDiscountToJson(this);
}