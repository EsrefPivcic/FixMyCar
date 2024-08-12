import 'package:json_annotation/json_annotation.dart';

part 'user_update_image.g.dart';

@JsonSerializable()
class UserUpdateImage {
  String image;

  UserUpdateImage(this.image);

  factory UserUpdateImage.fromJson(Map<String, dynamic> json) =>
      _$UserUpdateImageFromJson(json);

  Map<String, dynamic> toJson() => _$UserUpdateImageToJson(this);
}