import 'package:fixmycar_car_parts_shop/src/models/search_result.dart';
import 'package:fixmycar_car_parts_shop/src/providers/base_provider.dart';
import 'package:fixmycar_car_parts_shop/src/models/car_parts_shop_client_discount/car_parts_shop_client_discount.dart';

class CarPartsShopClientDiscountProvider extends BaseProvider<CarPartsShopClientDiscount, CarPartsShopClientDiscount> {
  List<CarPartsShopClientDiscount> discounts = [];
  int countOfItems = 0;
  bool isLoading = false;

  CarPartsShopClientDiscountProvider() : super('CarPartsShopClientDiscount/GetByCarPartsShop');

  Future<void> getByCarPartsShop() async {
    isLoading = true;
    notifyListeners();

    try {
      SearchResult<CarPartsShopClientDiscount> searchResult = await get(
        fromJson: (json) => CarPartsShopClientDiscount.fromJson(json),
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