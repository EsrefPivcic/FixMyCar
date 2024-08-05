import 'package:json_annotation/json_annotation.dart';

part 'order_detail.g.dart';

@JsonSerializable()
class OrderDetail {
  int id;
  int orderId;
  int storeItemId;
  String storeItemName;
  int quantity;
  double unitPrice;
  double totalItemsPrice;
  double totalItemsPriceDiscounted;
  double discount;

  OrderDetail(
      this.id,
      this.orderId,
      this.storeItemId,
      this.storeItemName,
      this.quantity,
      this.unitPrice,
      this.totalItemsPrice,
      this.totalItemsPriceDiscounted,
      this.discount
      );

  factory OrderDetail.fromJson(Map<String, dynamic> json) => _$OrderDetailFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailToJson(this);
}
