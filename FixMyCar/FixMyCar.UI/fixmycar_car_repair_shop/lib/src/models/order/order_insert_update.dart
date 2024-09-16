import 'package:fixmycar_car_repair_shop/src/models/store_item/store_item_order.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_insert_update.g.dart';

@JsonSerializable()
class OrderInsertUpdate {
  int? carPartsShopId;
  bool? userAddress;
  String? shippingCity;
  String? shippingAddress;
  String? shippingPostalCode;
  String? paymentMethod;
  List<StoreItemOrder>? storeItems;

  OrderInsertUpdate.n();

  OrderInsertUpdate(
      this.carPartsShopId,
      this.userAddress,
      this.shippingCity,
      this.shippingAddress,
      this.shippingPostalCode,
      this.paymentMethod,
      this.storeItems);

  factory OrderInsertUpdate.fromJson(Map<String, dynamic> json) =>
      _$OrderInsertUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$OrderInsertUpdateToJson(this);
}
