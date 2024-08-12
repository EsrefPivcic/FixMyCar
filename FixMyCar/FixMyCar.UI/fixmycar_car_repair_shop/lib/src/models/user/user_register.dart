import 'package:json_annotation/json_annotation.dart';

part 'user_register.g.dart';

@JsonSerializable()
class UserRegister {
  String name;
  String surname;
  String email;
  String phone;
  String username;
  String gender;
  String address;
  String postalCode;
  String password;
  String passwordConfirm;
  String? image;
  String city;

  UserRegister(
      this.name,
      this.surname,
      this.email,
      this.phone,
      this.username,
      this.gender,
      this.address,
      this.postalCode,
      this.password,
      this.passwordConfirm,
      this.image,
      this.city);

  factory UserRegister.fromJson(Map<String, dynamic> json) =>
      _$UserRegisterFromJson(json);

  Map<String, dynamic> toJson() => _$UserRegisterToJson(this);
}