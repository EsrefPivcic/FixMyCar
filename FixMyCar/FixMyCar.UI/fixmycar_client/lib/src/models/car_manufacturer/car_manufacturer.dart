import 'package:json_annotation/json_annotation.dart';

part 'car_manufacturer.g.dart';

@JsonSerializable()
class CarManufacturer {
  int id;
  String name;

  CarManufacturer(this.id, this.name);

  factory CarManufacturer.fromJson(Map<String, dynamic> json) => _$CarManufacturerFromJson(json);

  Map<String, dynamic> toJson() => _$CarManufacturerToJson(this);
}