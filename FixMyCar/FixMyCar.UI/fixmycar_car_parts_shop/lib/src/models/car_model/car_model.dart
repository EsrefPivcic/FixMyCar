import 'package:json_annotation/json_annotation.dart';

part 'car_model.g.dart';

@JsonSerializable()
class CarModel {
  int id;
  String name;
  String modelYear;

  CarModel(
      this.id, this.name, this.modelYear);

  factory CarModel.fromJson(Map<String, dynamic> json) => _$CarModelFromJson(json);

  Map<String, dynamic> toJson() => _$CarModelToJson(this);
}