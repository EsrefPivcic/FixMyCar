import 'package:json_annotation/json_annotation.dart';

part 'order_search_object.g.dart';

@JsonSerializable()
class OrderSearchObject {
  bool? discount;
  String? state;
  double? minTotalAmount;
  double? maxTotalAmount;
  DateTime? minOrderDate;
  DateTime? maxOrderDate;
  DateTime? minShippingDate;
  DateTime? maxShippingDate;

  OrderSearchObject.n({
    required this.minTotalAmount,
    required this.maxTotalAmount,
  });

  OrderSearchObject(
      this.discount,
      this.state,
      this.minTotalAmount,
      this.maxTotalAmount,
      this.minOrderDate,
      this.maxOrderDate,
      this.minShippingDate,
      this.maxShippingDate);

  factory OrderSearchObject.fromJson(Map<String, dynamic> json) =>
      _$OrderSearchObjectFromJson(json);

  Map<String?, dynamic> toJson() => _$OrderSearchObjectToJson(this);
}
