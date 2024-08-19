import 'package:json_annotation/json_annotation.dart';

part 'service_type.g.dart';

@JsonSerializable()
class ServiceType {
  int id;
  String name;
  String image;

  ServiceType(
      this.id,
      this.name,
      this.image);

  factory ServiceType.fromJson(Map<String, dynamic> json) =>
      _$ServiceTypeFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceTypeToJson(this);
}
