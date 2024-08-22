import 'package:json_annotation/json_annotation.dart';

part 'reservation.g.dart';

@JsonSerializable()
class Reservation {
  int id;
  String carRepairShopName;
  String clientUsername;
  int? orderId;
  String reservationCreatedDate;
  String reservationDate;
  String? completionDate;
  double totalAmount;
  String totalDuration;
  double carRepairShopDiscountValue;
  String state;
  String paymentMethod;

  Reservation(
      this.id,
      this.carRepairShopName,
      this.clientUsername,
      this.orderId,
      this.reservationCreatedDate,
      this.reservationDate,
      this.completionDate,
      this.totalAmount,
      this.totalDuration,
      this.carRepairShopDiscountValue,
      this.state,
      this.paymentMethod);

  factory Reservation.fromJson(Map<String, dynamic> json) => _$ReservationFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationToJson(this);
}
