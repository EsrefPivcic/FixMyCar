import 'package:json_annotation/json_annotation.dart';

part 'city_insert_update.g.dart';

@JsonSerializable()
class CityInsertUpdate {
  String name;

  CityInsertUpdate(this.name);

  factory CityInsertUpdate.fromJson(Map<String, dynamic> json) =>
      _$CityInsertUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$CityInsertUpdateToJson(this);
}
