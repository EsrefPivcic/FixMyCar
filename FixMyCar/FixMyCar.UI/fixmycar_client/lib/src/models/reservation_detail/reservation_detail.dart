import 'package:json_annotation/json_annotation.dart';

part 'reservation_detail.g.dart';

@JsonSerializable()
class ReservationDetail {
  int carRepairShopServiceId;
  String serviceName;
  double servicePrice;
  double serviceDiscount;
  double serviceDiscountedPrice;

  ReservationDetail(
      this.carRepairShopServiceId,
      this.serviceName,
      this.servicePrice,
      this.serviceDiscount,
      this.serviceDiscountedPrice
      );

  factory ReservationDetail.fromJson(Map<String, dynamic> json) => _$ReservationDetailFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationDetailToJson(this);
}
