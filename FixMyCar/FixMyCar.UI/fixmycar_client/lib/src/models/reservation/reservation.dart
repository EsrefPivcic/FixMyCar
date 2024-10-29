import 'package:json_annotation/json_annotation.dart';

part 'reservation.g.dart';

@JsonSerializable()
class Reservation {
  int id;
  int carRepairShopId;
  String carRepairShopName;
  String clientUsername;
  int? orderId;
  bool? clientOrder;
  String reservationCreatedDate;
  String reservationDate;
  String? estimatedCompletionDate;
  String? completionDate;
  double totalAmount;
  String totalDuration;
  double carRepairShopDiscountValue;
  String state;
  String type;

  Reservation(
      this.id,
      this.carRepairShopId,
      this.carRepairShopName,
      this.clientUsername,
      this.orderId,
      this.clientOrder,
      this.reservationCreatedDate,
      this.reservationDate,
      this.estimatedCompletionDate,
      this.completionDate,
      this.totalAmount,
      this.totalDuration,
      this.carRepairShopDiscountValue,
      this.state,
      this.type);

  factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationToJson(this);
}
