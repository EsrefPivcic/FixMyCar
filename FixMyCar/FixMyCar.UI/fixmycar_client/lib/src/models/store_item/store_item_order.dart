import 'package:json_annotation/json_annotation.dart';

part 'store_item_order.g.dart';

@JsonSerializable()
class StoreItemOrder {
  int storeItemId;
  int quantity;

  StoreItemOrder(this.storeItemId, this.quantity);

  factory StoreItemOrder.fromJson(Map<String, dynamic> json) =>
      _$StoreItemOrderFromJson(json);

  Map<String, dynamic> toJson() => _$StoreItemOrderToJson(this);
}
