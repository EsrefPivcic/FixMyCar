import 'package:fixmycar_client/src/models/search_result.dart';
import 'package:fixmycar_client/src/providers/base_provider.dart';
import 'package:fixmycar_client/src/models/car_repair_shop_discount/car_repair_shop_discount.dart';

class CarRepairShopDiscountProvider
    extends BaseProvider<CarRepairShopDiscount, CarRepairShopDiscount> {
  List<CarRepairShopDiscount> discounts = [];
  int countOfItems = 0;
  bool isLoading = false;

  CarRepairShopDiscountProvider() : super('CarRepairShopDiscount');

  Future<void> getByClient({required String carRepairShop}) async {
    isLoading = true;
    notifyListeners();

    Map<String, dynamic> queryParams = {};

    queryParams['CarRepairShopName'] = carRepairShop;

    try {
      SearchResult<CarRepairShopDiscount> searchResult = await get(
        customEndpoint: 'GetByClient',
        filter: queryParams,
        fromJson: (json) => CarRepairShopDiscount.fromJson(json),
      );

      discounts = searchResult.result;
      countOfItems = searchResult.count;
      isLoading = false;

      notifyListeners();
    } catch (e) {
      discounts = [];
      countOfItems = 0;
      isLoading = false;

      notifyListeners();
    }
  }
}
