import 'package:fixmycar_client/src/models/car_model/car_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'store_item.g.dart';

@JsonSerializable()
class StoreItem {
  int id;
  String name;
  double price;
  String state;
  double discount;
  double discountedPrice;
  String? imageData;
  String? details;
  List<CarModel>? carModels;
  int? storeItemCategoryId;
  String? category;

  StoreItem(
      this.id, this.name, this.price, this.state, this.discount, this.discountedPrice, this.imageData, this.details, this.carModels, this.storeItemCategoryId, this.category);

  factory StoreItem.fromJson(Map<String, dynamic> json) => _$StoreItemFromJson(json);

  Map<String, dynamic> toJson() => _$StoreItemToJson(this);
}