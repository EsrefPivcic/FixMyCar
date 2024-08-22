import 'package:json_annotation/json_annotation.dart';

part 'reservation_search_object.g.dart';

@JsonSerializable()
class ReservationSearchObject {
  bool? discount;
  String? state;
  double? minTotalAmount;
  double? maxTotalAmount;
  DateTime? minCreatedDate;
  DateTime? maxCreatedDate;
  DateTime? minReservationDate;
  DateTime? maxReservationDate;
  DateTime? minCompletionDate;
  DateTime? maxCompletionDate;

  ReservationSearchObject.n({
    required this.minTotalAmount,
    required this.maxTotalAmount,
  });

  ReservationSearchObject(
      this.discount,
      this.state,
      this.minTotalAmount,
      this.maxTotalAmount,
      this.minCreatedDate,
      this.maxCreatedDate,
      this.minReservationDate,
      this.maxReservationDate,
      this.minCompletionDate,
      this.maxCompletionDate);

  factory ReservationSearchObject.fromJson(Map<String, dynamic> json) =>
      _$ReservationSearchObjectFromJson(json);

  Map<String?, dynamic> toJson() => _$ReservationSearchObjectToJson(this);
}