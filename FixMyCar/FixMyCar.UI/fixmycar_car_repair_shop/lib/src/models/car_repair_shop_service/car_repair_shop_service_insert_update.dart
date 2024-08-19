import 'package:json_annotation/json_annotation.dart';

part 'car_repair_shop_service_insert_update.g.dart';

@JsonSerializable()
class CarRepairShopServiceInsertUpdate {
  int? serviceTypeId;
  String? name;
  double? price;
  double? discount;
  String? imageData;
  String? details;
  String? duration;

  CarRepairShopServiceInsertUpdate.n();

  CarRepairShopServiceInsertUpdate(
      this.serviceTypeId,
      this.name,
      this.price,
      this.discount,
      this.imageData,
      this.details,
      this.duration);

  factory CarRepairShopServiceInsertUpdate.fromJson(Map<String, dynamic> json) =>
      _$CarRepairShopServiceInsertUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$CarRepairShopServiceInsertUpdateToJson(this);
}
