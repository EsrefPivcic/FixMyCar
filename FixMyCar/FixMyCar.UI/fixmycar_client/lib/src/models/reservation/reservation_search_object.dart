import 'package:json_annotation/json_annotation.dart';

part 'reservation_search_object.g.dart';

@JsonSerializable()
class ReservationSearchObject {
  bool? discount;
  String? state;
  String? type;
  double? minTotalAmount;
  double? maxTotalAmount;
  bool? clientOrder;
  DateTime? minCreatedDate;
  DateTime? maxCreatedDate;
  DateTime? minReservationDate;
  DateTime? maxReservationDate;
  DateTime? minEstimatedCompletionDate;
  DateTime? maxEstimatedCompletionDate;
  DateTime? minCompletionDate;
  DateTime? maxCompletionDate;

  ReservationSearchObject.n({
    required this.minTotalAmount,
    required this.maxTotalAmount,
  });

  ReservationSearchObject(
      this.discount,
      this.state,
      this.type,
      this.minTotalAmount,
      this.maxTotalAmount,
      this.clientOrder,
      this.minCreatedDate,
      this.maxCreatedDate,
      this.minReservationDate,
      this.maxReservationDate,
      this.minEstimatedCompletionDate,
      this.maxEstimatedCompletionDate,
      this.minCompletionDate,
      this.maxCompletionDate);

  factory ReservationSearchObject.fromJson(Map<String, dynamic> json) =>
      _$ReservationSearchObjectFromJson(json);

  Map<String?, dynamic> toJson() => _$ReservationSearchObjectToJson(this);
}