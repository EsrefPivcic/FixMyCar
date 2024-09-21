import 'package:json_annotation/json_annotation.dart';

part 'order_essential.g.dart';

@JsonSerializable()
class OrderEssential {
  String carPartsShopName;
  String username;
  String orderDate;
  String? shippingDate;
  String state;
  List<String> items;

  OrderEssential(this.carPartsShopName, this.username, this.orderDate,
      this.shippingDate, this.state, this.items);

  factory OrderEssential.fromJson(Map<String, dynamic> json) =>
      _$OrderEssentialFromJson(json);

  Map<String, dynamic> toJson() => _$OrderEssentialToJson(this);
}
