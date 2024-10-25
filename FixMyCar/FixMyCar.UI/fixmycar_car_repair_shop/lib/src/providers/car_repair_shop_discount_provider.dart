import 'package:fixmycar_car_repair_shop/src/models/search_result.dart';
import 'package:fixmycar_car_repair_shop/src/providers/base_provider.dart';
import 'package:fixmycar_car_repair_shop/src/models/car_repair_shop_discount/car_repair_shop_discount.dart';
import 'package:fixmycar_car_repair_shop/src/models/car_repair_shop_discount/car_repair_shop_discount_insert_update.dart';

class CarRepairShopDiscountProvider extends BaseProvider<CarRepairShopDiscount,
    CarRepairShopDiscountInsertUpdate> {
  List<CarRepairShopDiscount> discounts = [];
  int countOfItems = 0;
  bool isLoading = false;

  CarRepairShopDiscountProvider() : super('CarRepairShopDiscount');

  Future<void> getByCarRepairShop(
      {required int pageNumber, required int pageSize, bool? active}) async {
    isLoading = true;
    notifyListeners();

    Map<String, dynamic> queryParams = {};

    queryParams['PageNumber'] = pageNumber.toString();
    queryParams['PageSize'] = pageSize.toString();

    if (active != null) {
      queryParams['Active'] = active.toString();
    }

    try {
      SearchResult<CarRepairShopDiscount> searchResult = await get(
        customEndpoint: 'GetByCarRepairShop',
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

  Future<void> updateDiscount(
      int id, CarRepairShopDiscountInsertUpdate discount) async {
    await update(
        id: id, item: discount, toJson: (storeItem) => storeItem.toJson());
  }

  Future<void> insertDiscount(
      CarRepairShopDiscountInsertUpdate discount) async {
    await insert(
      discount,
      toJson: (storeItem) => storeItem.toJson(),
    );
  }
}
