import 'package:json_annotation/json_annotation.dart';

part 'car_repair_shop_discount_insert_update.g.dart';

@JsonSerializable()
class CarRepairShopDiscountInsertUpdate {
  String? username;
  double? value;
  bool? revoked;

  CarRepairShopDiscountInsertUpdate.n();

  CarRepairShopDiscountInsertUpdate(this.username, this.value, this.revoked);

  factory CarRepairShopDiscountInsertUpdate.fromJson(
          Map<String, dynamic> json) =>
      _$CarRepairShopDiscountInsertUpdateFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CarRepairShopDiscountInsertUpdateToJson(this);
}
