import 'package:json_annotation/json_annotation.dart';

part 'user_minimal.g.dart';

@JsonSerializable()
class UserMinimal {
  int id;
  String username;
  String name;
  String surname;
  String? image;

  UserMinimal(this.id, this.username, this.name, this.surname, this.image);

  factory UserMinimal.fromJson(Map<String, dynamic> json) =>
      _$UserMinimalFromJson(json);

  Map<String, dynamic> toJson() => _$UserMinimalToJson(this);
}
