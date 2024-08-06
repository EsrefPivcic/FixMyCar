import 'package:fixmycar_car_parts_shop/src/models/order/order.dart';
import 'package:fixmycar_car_parts_shop/src/models/search_result.dart';
import 'package:fixmycar_car_parts_shop/src/providers/base_provider.dart';
import 'package:fixmycar_car_parts_shop/src/models/order/order_accept.dart';
import 'package:http/http.dart' as http;

class OrderProvider extends BaseProvider<Order, OrderAccept> {
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

  Future<void> accept(int id, OrderAccept orderAccept) async {
    await update(
        id: id,
        item: orderAccept,
        toJson: (orderAccept) => orderAccept.toJson(),
        customEndpoint: 'Accept');
  }

  Future<void> reject(int id) async {
    try {
      final response = await http.put(
        Uri.parse(
            '${BaseProvider.baseUrl}/$endpoint/Reject/$id'),
        headers: await createHeaders()
      );
      if (response.statusCode == 200) {
        print('Reject successful.');
        notifyListeners();
      } else {
        throw Exception(
            'Failed to reject the order. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error rejectig the order: $e');
      rethrow;
    }
  }
}
