import 'package:fixmycar_car_parts_shop/src/models/order_detail/order_detail.dart';
import 'package:fixmycar_car_parts_shop/src/models/search_result.dart';
import 'package:fixmycar_car_parts_shop/src/providers/base_provider.dart';

class OrderDetailsProvider extends BaseProvider<OrderDetail, OrderDetail> {
  List<OrderDetail> orderDetails = [];
  int countOfItems = 0;
  bool isLoading = false;

  OrderDetailsProvider() : super('OrderDetail');

  Future<void> getByOrder({
    required int id
  }) async {
    isLoading = true;
    notifyListeners();

    Map<String, dynamic> queryParams = {};

    queryParams['OrderId'] = id;

    try {
      SearchResult<OrderDetail> searchResult = await get(
        customEndpoint: 'GetByOrder',
        filter: queryParams,
        fromJson: (json) => OrderDetail.fromJson(json),
      );

      orderDetails = searchResult.result;
      countOfItems = searchResult.count;
      isLoading = false;

      notifyListeners();
    } catch (e) {
      orderDetails = [];
      countOfItems = 0;
      isLoading = false;
      
      notifyListeners();
    }
  }
}