// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportFilter _$ReportFilterFromJson(Map<String, dynamic> json) => ReportFilter(
      json['username'] as String?,
      json['role'] as String?,
      json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$ReportFilterToJson(ReportFilter instance) =>
    <String, dynamic>{
      'username': instance.username,
      'role': instance.role,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
    };
