import 'package:fixmycar_client/src/models/car_parts_shop_discount/car_parts_shop_discount.dart';
import 'package:fixmycar_client/src/models/search_result.dart';
import 'package:fixmycar_client/src/providers/base_provider.dart';

class CarPartsShopDiscountProvider
    extends BaseProvider<CarPartsShopDiscount, CarPartsShopDiscount> {
  List<CarPartsShopDiscount> discounts = [];
  int countOfItems = 0;
  bool isLoading = false;

  CarPartsShopDiscountProvider() : super('CarPartsShopClientDiscount');

  Future<void> getByClient({required String carPartsShop}) async {
    isLoading = true;
    notifyListeners();

    Map<String, dynamic> queryParams = {};

    queryParams['CarPartsShopName'] = carPartsShop;

    try {
      SearchResult<CarPartsShopDiscount> searchResult = await get(
        customEndpoint: 'GetByClient',
        filter: queryParams,
        fromJson: (json) => CarPartsShopDiscount.fromJson(json),
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
