import 'package:json_annotation/json_annotation.dart';

part 'report_filter.g.dart';

@JsonSerializable()
class ReportFilter {
  String? username;
  String? role;
  DateTime? startDate;
  DateTime? endDate;

  ReportFilter(this.username, this.role, this.startDate, this.endDate);

  factory ReportFilter.fromJson(Map<String, dynamic> json) =>
      _$ReportFilterFromJson(json);

  Map<String, dynamic> toJson() => _$ReportFilterToJson(this);
}
