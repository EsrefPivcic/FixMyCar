import 'package:fixmycar_car_repair_shop/src/models/store_item/store_item.dart';
import 'package:fixmycar_car_repair_shop/src/models/search_result.dart';
import 'package:fixmycar_car_repair_shop/src/providers/base_provider.dart';

class StoreItemProvider extends BaseProvider<StoreItem, StoreItem> {
  List<StoreItem> items = [];
  int countOfItems = 0;
  bool isLoading = false;

  StoreItemProvider() : super('StoreItem');

  Future<void> getStoreItems({
    required int pageNumber,
    required int pageSize,
    required carPartsShopName,
    String? nameFilter,
    bool? withDiscount,
    String? state,
    int? categoryFilter,
    int? carManufacturerId,
    List<int>? carModelsFilter,
  }) async {
    isLoading = true;
    notifyListeners();

    Map<String, dynamic> queryParams = {};

    queryParams['PageNumber'] = pageNumber.toString();
    queryParams['PageSize'] = pageSize.toString();
    queryParams['CarPartsShopName'] = carPartsShopName;
    queryParams['State'] = "active";

    if (nameFilter != null && nameFilter.isNotEmpty) {
      queryParams['Contains'] = nameFilter;
    }
    if (withDiscount != null) {
      queryParams['WithDiscount'] = withDiscount.toString();
    }
    if (categoryFilter != null) {
      queryParams['StoreItemCategoryId'] = categoryFilter.toString();
    }
    if (carManufacturerId != null) {
      queryParams['CarManufacturerId'] = carManufacturerId.toString();
    }
    if (carModelsFilter != null && carModelsFilter.isNotEmpty) {
      queryParams['CarModelIds'] =
          carModelsFilter.map((carModel) => carModel.toString()).toList();
    }

    try {
      SearchResult<StoreItem> searchResult = await get(
          filter: queryParams, fromJson: (json) => StoreItem.fromJson(json));

      items = searchResult.result;
      countOfItems = searchResult.count;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      items = [];
      countOfItems = 0;
      isLoading = false;
      notifyListeners();
    }
  }
}
