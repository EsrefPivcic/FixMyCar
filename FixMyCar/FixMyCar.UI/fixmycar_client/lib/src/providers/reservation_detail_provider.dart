import 'package:fixmycar_client/src/models/reservation_detail/reservation_detail.dart';
import 'package:fixmycar_client/src/models/search_result.dart';
import 'package:fixmycar_client/src/providers/base_provider.dart';

class ReservationDetailProvider
    extends BaseProvider<ReservationDetail, ReservationDetail> {
  List<ReservationDetail> reservationDetails = [];
  int countOfItems = 0;
  bool isLoading = false;

  ReservationDetailProvider() : super('ReservationDetail');

  Future<void> getByReservation({required int id}) async {
    isLoading = true;
    notifyListeners();

    Map<String, dynamic> queryParams = {};

    queryParams['ReservationId'] = id.toString();

    try {
      SearchResult<ReservationDetail> searchResult = await get(
        filter: queryParams,
        fromJson: (json) => ReservationDetail.fromJson(json),
      );

      reservationDetails = searchResult.result;
      countOfItems = searchResult.count;
      isLoading = false;

      notifyListeners();
    } catch (e) {
      reservationDetails = [];
      countOfItems = 0;
      isLoading = false;

      notifyListeners();
    }
  }
}
