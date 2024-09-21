import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int id;
  String name;
  String surname;
  String email;
  String phone;
  String username;
  String created;
  String gender;
  String address;
  String postalCode;
  String? image;
  String role;
  String city;
  bool active;
  List<String>? workDays;
  String? openingTime;
  String? closingTime;
  String? workingHours;

  User(
      this.id,
      this.name,
      this.surname,
      this.email,
      this.phone,
      this.username,
      this.created,
      this.gender,
      this.address,
      this.postalCode,
      this.image,
      this.role,
      this.city,
      this.active,
      this.workDays,
      this.openingTime,
      this.closingTime,
      this.workingHours);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
