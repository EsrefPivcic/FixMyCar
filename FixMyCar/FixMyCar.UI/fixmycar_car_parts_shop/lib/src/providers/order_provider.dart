import 'package:fixmycar_car_parts_shop/src/models/order/order.dart';
import 'package:fixmycar_car_parts_shop/src/models/search_result.dart';
import 'package:fixmycar_car_parts_shop/src/providers/base_provider.dart';

class OrderProvider extends BaseProvider<Order, Order> {
  List<Order> orders = [];
  int countOfItems = 0;
  bool isLoading = false;

  OrderProvider() : super('Order');

  Future<void> getByCarPartsShop() async {
    isLoading = true;
    notifyListeners();

    try {
      SearchResult<Order> searchResult = await get(
        customEndpoint: 'GetByCarPartsShop',
        fromJson: (json) => Order.fromJson(json),
      );

      orders = searchResult.result;
      countOfItems = searchResult.count;
      isLoading = false;

      notifyListeners();
    } catch (e) {
      orders = [];
      countOfItems = 0;
      isLoading = false;
      
      notifyListeners();
    }
  }
}