import 'package:fixmycar_client/src/models/store_item/store_item_order.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_insert_update.g.dart';

@JsonSerializable()
class OrderInsertUpdate {
  int? carPartsShopId;
  bool? userAddress;
  int? cityId;
  String? shippingAddress;
  String? shippingPostalCode;
  List<StoreItemOrder>? storeItems;

  OrderInsertUpdate.n();

  OrderInsertUpdate(this.carPartsShopId, this.userAddress, this.cityId,
      this.shippingAddress, this.shippingPostalCode, this.storeItems);

  factory OrderInsertUpdate.fromJson(Map<String, dynamic> json) =>
      _$OrderInsertUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$OrderInsertUpdateToJson(this);
}
