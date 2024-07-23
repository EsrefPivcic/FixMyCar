import 'package:json_annotation/json_annotation.dart';
import 'package:fixmycar_car_parts_shop/src/models/car_model/car_model.dart';

part 'store_item.g.dart';

@JsonSerializable()
class StoreItem {
  int id;
  String? name;
  String state;
  double discount;
  String? imageData;
  String? imageMimeType;
  String? details;
  List<CarModel> carModels;
  int storeItemCategoryId;
  String category;

  StoreItem(
      this.id, this.name, this.state, this.discount, this.imageData, this.imageMimeType, this.details, this.carModels, this.storeItemCategoryId, this.category);

  factory StoreItem.fromJson(Map<String, dynamic> json) => _$StoreItemFromJson(json);

  Map<String, dynamic> toJson() => _$StoreItemToJson(this);
}