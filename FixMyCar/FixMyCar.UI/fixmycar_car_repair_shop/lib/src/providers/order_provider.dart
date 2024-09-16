import 'package:fixmycar_car_repair_shop/src/models/order/order.dart';
import 'package:fixmycar_car_repair_shop/src/models/order/order_insert_update.dart';
import 'package:fixmycar_car_repair_shop/src/models/order/order_search_object.dart';
import 'package:fixmycar_car_repair_shop/src/models/search_result.dart';
import 'package:fixmycar_car_repair_shop/src/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class OrderProvider extends BaseProvider<Order, OrderInsertUpdate> {
  List<Order> orders = [];
  int countOfItems = 0;
  bool isLoading = false;

  OrderProvider() : super('Order');

  Future<void> getByCarRepairShop({OrderSearchObject? orderSearch}) async {
    isLoading = true;
    notifyListeners();

    Map<String, dynamic> queryParams = {};

    if (orderSearch != null) {
      if (orderSearch.discount != null) {
        queryParams['Discount'] = orderSearch.discount.toString();
      }
      if (orderSearch.state != null) {
        if (orderSearch.state!.isNotEmpty) {
          queryParams['State'] = orderSearch.state;
        }
      }
      if (orderSearch.minTotalAmount != null) {
        queryParams['MinTotalAmount'] = orderSearch.minTotalAmount.toString();
      }
      if (orderSearch.maxTotalAmount != null) {
        queryParams['MaxTotalAmount'] = orderSearch.maxTotalAmount.toString();
      }
      if (orderSearch.minOrderDate != null) {
        queryParams['MinOrderDate'] = orderSearch.minOrderDate.toString();
      }
      if (orderSearch.maxOrderDate != null) {
        queryParams['MaxOrderDate'] = orderSearch.maxOrderDate.toString();
      }
      if (orderSearch.minShippingDate != null) {
        queryParams['MinShippingDate'] = orderSearch.minShippingDate.toString();
      }
      if (orderSearch.maxShippingDate != null) {
        queryParams['MaxShippingDate'] = orderSearch.maxShippingDate.toString();
      }
    }

    try {
      SearchResult<Order> searchResult = await get(
        customEndpoint: 'GetByCarRepairShop',
        filter: queryParams,
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

  Future<void> insertOrder(OrderInsertUpdate order) async {
    await insert(
      order,
      toJson: (service) => service.toJson(),
    );
  }

  Future<void> updateOrder(int id, OrderInsertUpdate orderUpdate) async {
    await update(
        id: id,
        item: orderUpdate,
        toJson: (orderUpdate) => orderUpdate.toJson());
  }

  Future<void> cancel(int id) async {
    try {
      final response = await http.put(
          Uri.parse('${BaseProvider.baseUrl}/$endpoint/Cancel/$id'),
          headers: await createHeaders());
      if (response.statusCode == 200) {
        print('Cancel successful.');
        notifyListeners();
      } else {
        throw Exception(
            'Failed to cancel the order. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error canceling the order: $e');
      rethrow;
    }
  }

  Future<void> resend(int id) async {
    try {
      final response = await http.put(
          Uri.parse('${BaseProvider.baseUrl}/$endpoint/Resend/$id'),
          headers: await createHeaders());
      if (response.statusCode == 200) {
        print('Resend successful.');
        notifyListeners();
      } else {
        throw Exception(
            'Failed to resend the order. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error resending the order: $e');
      rethrow;
    }
  }
}
