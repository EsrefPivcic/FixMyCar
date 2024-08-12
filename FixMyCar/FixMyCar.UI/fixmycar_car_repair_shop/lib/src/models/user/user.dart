import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
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

  User(
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
      this.city);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
