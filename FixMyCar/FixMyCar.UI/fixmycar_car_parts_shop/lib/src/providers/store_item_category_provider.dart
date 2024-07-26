import 'package:fixmycar_car_parts_shop/src/models/search_result.dart';
import 'package:fixmycar_car_parts_shop/src/providers/base_provider.dart';
import 'package:fixmycar_car_parts_shop/src/models/store_item_category/store_item_category.dart';

class StoreItemCategoryProvider extends BaseProvider<StoreItemCategory, StoreItemCategory> {
  List<StoreItemCategory> categories = [];
  int countOfItems = 0;
  bool isLoading = false;

  StoreItemCategoryProvider() : super('StoreItemCategory');

  Future<void> getCategories() async {
    isLoading = true;
    notifyListeners();

    try {
      SearchResult<StoreItemCategory> searchResult = await get(
        fromJson: (json) => StoreItemCategory.fromJson(json),
      );

      categories = searchResult.result;
      countOfItems = searchResult.count;
      isLoading = false;

      notifyListeners();
    } catch (e) {
      categories = [];
      countOfItems = 0;
      isLoading = false;

      notifyListeners();
    }
  }
}