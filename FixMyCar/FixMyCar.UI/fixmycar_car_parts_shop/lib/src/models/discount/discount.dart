import 'package:json_annotation/json_annotation.dart';

part 'discount.g.dart';

@JsonSerializable()
class Discount {
  int? id;
  double value;

  Discount(this.id, this.value);

  factory Discount.fromJson(Map<String, dynamic> json) =>
      _$DiscountFromJson(json);

  Map<String, dynamic> toJson() => _$DiscountToJson(this);
}
