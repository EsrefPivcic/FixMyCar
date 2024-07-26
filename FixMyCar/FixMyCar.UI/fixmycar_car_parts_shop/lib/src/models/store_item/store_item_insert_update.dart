import 'package:json_annotation/json_annotation.dart';

part 'store_item_insert_update.g.dart';

@JsonSerializable()
class StoreItemInsertUpdate {
  String? name;
  double? price;
  double? discount;
  String? imageData;
  String? details;
  List<int>? carModelIds;
  int? storeItemCategoryId;

  StoreItemInsertUpdate.n();

  StoreItemInsertUpdate(
      this.name, this.price, this.discount, this.imageData, this.details, this.carModelIds, this.storeItemCategoryId);

  factory StoreItemInsertUpdate.fromJson(Map<String, dynamic> json) => _$StoreItemInsertUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$StoreItemInsertUpdateToJson(this);
}