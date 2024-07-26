import 'package:json_annotation/json_annotation.dart';

part 'store_item_update.g.dart';

@JsonSerializable()
class StoreItemUpdate {
  String? name;
  double? price;
  double? discount;
  String? imageData;
  String? details;
  List<int>? carModelIds;
  int? storeItemCategoryId;

  StoreItemUpdate.n();

  StoreItemUpdate(
      this.name, this.price, this.discount, this.imageData, this.details, this.carModelIds, this.storeItemCategoryId);

  factory StoreItemUpdate.fromJson(Map<String, dynamic> json) => _$StoreItemUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$StoreItemUpdateToJson(this);
}