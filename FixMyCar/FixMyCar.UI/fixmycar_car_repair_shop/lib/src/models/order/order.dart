import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  int id;
  String carPartsShopName;
  String username;
  String orderDate;
  String? shippingDate;
  double totalAmount;
  double clientDiscountValue;
  String state;
  int cityId;
  String shippingCity;
  String shippingAddress;
  String shippingPostalCode;

  Order(
      this.id,
      this.carPartsShopName,
      this.username,
      this.orderDate,
      this.shippingDate,
      this.totalAmount,
      this.clientDiscountValue,
      this.state,
      this.cityId,
      this.shippingCity,
      this.shippingAddress,
      this.shippingPostalCode);

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
