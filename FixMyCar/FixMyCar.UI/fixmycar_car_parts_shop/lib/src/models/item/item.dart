import 'package:fixmycar_car_parts_shop/src/models/discount/discount.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item.g.dart';

@JsonSerializable()
class Item {
  String? name;
  String state;
  Discount? discount;
  String? imageData;
  String? imageMimeType;

  Item(
      this.name, this.state, this.discount, this.imageData, this.imageMimeType);

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
