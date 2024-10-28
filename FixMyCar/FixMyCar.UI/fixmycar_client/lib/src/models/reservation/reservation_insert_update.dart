import 'package:json_annotation/json_annotation.dart';

part 'reservation_insert_update.g.dart';

@JsonSerializable()
class ReservationInsertUpdate {
  int? carRepairShopId;
  int? carModelId;
  int? orderId;
  bool? clientOrder;
  DateTime? reservationDate;
  List<int>? services;

  ReservationInsertUpdate.n();

  ReservationInsertUpdate(this.carRepairShopId, this.carModelId, this.orderId,
      this.clientOrder, this.reservationDate, this.services);

  factory ReservationInsertUpdate.fromJson(Map<String, dynamic> json) =>
      _$ReservationInsertUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationInsertUpdateToJson(this);
}
