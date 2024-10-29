import 'package:json_annotation/json_annotation.dart';

part 'date_availability.g.dart';

@JsonSerializable()
class DateAvailability {
  String date;
  String freeHours;

  DateAvailability(this.date, this.freeHours);

  factory DateAvailability.fromJson(Map<String, dynamic> json) =>
      _$DateAvailabilityFromJson(json);

  Map<String, dynamic> toJson() => _$DateAvailabilityToJson(this);
}
