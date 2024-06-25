import 'package:json_annotation/json_annotation.dart';

part 'store_item.g.dart';

@JsonSerializable()
class StoreItem {
  int id;
  String? name;
  String state;
  double discount;
  String? imageData;
  String? imageMimeType;

  StoreItem(
      this.id, this.name, this.state, this.discount, this.imageData, this.imageMimeType);

  factory StoreItem.fromJson(Map<String, dynamic> json) => _$StoreItemFromJson(json);

  Map<String, dynamic> toJson() => _$StoreItemToJson(this);
}
