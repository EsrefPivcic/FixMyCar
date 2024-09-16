import 'package:fixmycar_car_repair_shop/src/models/order/order_essential.dart';
import 'package:fixmycar_car_repair_shop/src/models/order/order_insert_update.dart';
import 'package:fixmycar_car_repair_shop/src/providers/base_provider.dart';

class OrderEssentialProvider
    extends BaseProvider<OrderEssential, OrderInsertUpdate> {
  List<OrderEssential> ordersEssential = [];

  int countOfItems = 0;
  bool isLoading = false;

  OrderEssential? orderEssential;

  OrderEssentialProvider() : super('Order');

  Future<void> getOrderEssentialById({required int orderId}) async {
    isLoading = true;
    notifyListeners();

    try {
      OrderEssential result = await getById(
        customEndpoint: 'GetBasicOrderInfo',
        id: orderId,
        fromJson: (json) => OrderEssential.fromJson(json),
      );

      orderEssential = result;
      isLoading = false;

      notifyListeners();
    } catch (e) {
      orderEssential = null;
      isLoading = false;
      notifyListeners();
    }
  }
}
