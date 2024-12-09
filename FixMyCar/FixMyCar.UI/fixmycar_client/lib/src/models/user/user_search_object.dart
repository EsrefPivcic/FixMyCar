import 'package:json_annotation/json_annotation.dart';

part 'user_search_object.g.dart';

@JsonSerializable()
class UserSearchObject {
  String? containsUsername;
  bool? active;
  String? role;
  int? cityId;

  UserSearchObject.n();

  UserSearchObject(this.containsUsername, this.active, this.role, this.cityId);

  factory UserSearchObject.fromJson(Map<String, dynamic> json) =>
      _$UserSearchObjectFromJson(json);

  Map<String, dynamic> toJson() => _$UserSearchObjectToJson(this);
}
