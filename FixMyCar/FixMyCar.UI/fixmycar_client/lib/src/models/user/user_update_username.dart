import 'package:json_annotation/json_annotation.dart';

part 'user_update_username.g.dart';

@JsonSerializable()
class UserUpdateUsername {
  String newUsername;
  String password;

  UserUpdateUsername(this.newUsername, this.password);

  factory UserUpdateUsername.fromJson(Map<String, dynamic> json) =>
      _$UserUpdateUsernameFromJson(json);

  Map<String, dynamic> toJson() => _$UserUpdateUsernameToJson(this);
}