import 'package:json_annotation/json_annotation.dart';

part 'store_item_category.g.dart';

@JsonSerializable()
class StoreItemCategory {
  int id;
  String name;

  StoreItemCategory(this.id, this.name);

  factory StoreItemCategory.fromJson(Map<String, dynamic> json) => _$StoreItemCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$StoreItemCategoryToJson(this);
}