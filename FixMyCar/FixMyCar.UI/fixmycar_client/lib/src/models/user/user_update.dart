import 'package:json_annotation/json_annotation.dart';

part 'user_update.g.dart';

@JsonSerializable()
class UserUpdate {
  String? name;
  String? surname;
  String? email;
  String? phone;
  String? gender;
  String? address;
  String? postalCode;
  int? cityId;

  UserUpdate(this.name, this.surname, this.email, this.phone, this.gender,
      this.address, this.postalCode, this.cityId);

  factory UserUpdate.fromJson(Map<String, dynamic> json) =>
      _$UserUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$UserUpdateToJson(this);
}
