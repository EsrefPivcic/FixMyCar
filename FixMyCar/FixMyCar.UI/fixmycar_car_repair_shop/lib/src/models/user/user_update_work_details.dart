import 'package:json_annotation/json_annotation.dart';

part 'user_update_work_details.g.dart';

@JsonSerializable()
class UserUpdateWorkDetails {
  List<int> workDays;
  String openingTime;
  String closingTime;
  int employees;

  UserUpdateWorkDetails(
      this.workDays, this.openingTime, this.closingTime, this.employees);

  factory UserUpdateWorkDetails.fromJson(Map<String, dynamic> json) =>
      _$UserUpdateWorkDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$UserUpdateWorkDetailsToJson(this);
}
