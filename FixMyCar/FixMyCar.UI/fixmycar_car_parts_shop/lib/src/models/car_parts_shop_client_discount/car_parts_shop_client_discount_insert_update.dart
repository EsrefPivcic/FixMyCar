import 'package:json_annotation/json_annotation.dart';

part 'car_parts_shop_client_discount_insert_update.g.dart';

@JsonSerializable()
class CarPartsShopClientDiscountInsertUpdate {
  String? username;
  double? value;
  bool? revoked;

  CarPartsShopClientDiscountInsertUpdate.n();

  CarPartsShopClientDiscountInsertUpdate(
      this.username, this.value, this.revoked);

  factory CarPartsShopClientDiscountInsertUpdate.fromJson(
          Map<String, dynamic> json) =>
      _$CarPartsShopClientDiscountInsertUpdateFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CarPartsShopClientDiscountInsertUpdateToJson(this);
}
