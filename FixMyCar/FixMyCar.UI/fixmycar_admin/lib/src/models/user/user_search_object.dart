import 'package:json_annotation/json_annotation.dart';

part 'user_search_object.g.dart';

@JsonSerializable()
class UserSearchObject {
  String? containsUsername;
  bool? active;
  String? role;

  UserSearchObject.n();

  UserSearchObject(
      this.containsUsername, this.active, this.role);

  factory UserSearchObject.fromJson(Map<String, dynamic> json) =>
      _$UserSearchObjectFromJson(json);

  Map<String, dynamic> toJson() => _$UserSearchObjectToJson(this);
}
