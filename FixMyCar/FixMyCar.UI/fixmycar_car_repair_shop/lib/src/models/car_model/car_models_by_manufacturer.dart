import 'package:fixmycar_car_repair_shop/src/models/car_manufacturer/car_manufacturer.dart';
import 'package:fixmycar_car_repair_shop/src/models/car_model/car_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'car_models_by_manufacturer.g.dart';

@JsonSerializable()
class CarModelsByManufacturer {
  CarManufacturer manufacturer;
  List<CarModel> models;

  CarModelsByManufacturer(this.manufacturer, this.models);

  factory CarModelsByManufacturer.fromJson(Map<String, dynamic> json) => _$CarModelsByManufacturerFromJson(json);

  Map<String, dynamic> toJson() => _$CarModelsByManufacturerToJson(this);
}