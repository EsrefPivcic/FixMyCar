import 'package:json_annotation/json_annotation.dart';

part 'reservation_insert_update.g.dart';

@JsonSerializable()
class ReservationInsertUpdate {
  int? carRepairShopId;
  int? orderId;
  bool? clientOrder;
  DateTime? reservationDate;
  String? paymentMethod;
  List<int>? services;

  ReservationInsertUpdate.n();

  ReservationInsertUpdate(this.carRepairShopId, this.orderId, this.clientOrder,
      this.reservationDate, this.paymentMethod, this.services);

  factory ReservationInsertUpdate.fromJson(Map<String, dynamic> json) =>
      _$ReservationInsertUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationInsertUpdateToJson(this);
}
