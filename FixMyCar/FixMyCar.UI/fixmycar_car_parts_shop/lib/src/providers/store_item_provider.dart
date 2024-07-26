import 'package:fixmycar_car_parts_shop/src/models/store_item/store_item.dart';
import 'package:fixmycar_car_parts_shop/src/models/search_result.dart';
import 'package:fixmycar_car_parts_shop/src/models/store_item/store_item_update.dart';
import 'package:fixmycar_car_parts_shop/src/providers/base_provider.dart';

class StoreItemProvider extends BaseProvider<StoreItem, StoreItemUpdate> {
  List<StoreItem> items = [];
  int countOfItems = 0;
  bool isLoading = false;

  StoreItemProvider() : super('StoreItem');

  Future<void> getStoreItems({
    String? nameFilter,
    bool? withDiscount,
    String? state,
  }) async {
    isLoading = true;
    notifyListeners();

    Map<String, String> queryParams = {};

    if (nameFilter != null && nameFilter.isNotEmpty) {
      queryParams['Contains'] = nameFilter;
    }
    if (withDiscount != null) {
      queryParams['WithDiscount'] = withDiscount.toString();
    }
    if (state != null && state.isNotEmpty) {
      queryParams['State'] = state;
    }

    try {
      SearchResult<StoreItem> searchResult = await get(
        filter: queryParams,
        fromJson: (json) => StoreItem.fromJson(json),
      );

      items = searchResult.result;
      countOfItems = searchResult.count;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      items = [];
      countOfItems = 0;
      isLoading = false;
      notifyListeners();
      print('Error fetching items: $e');
    }
  }

  Future<void> updateStoreItem(int id, StoreItemUpdate sotreitem) async {
    try {
      await update(
        id,
        sotreitem,
        toJson: (storeItem) => storeItem.toJson(),
      );
      print('StoreItem updated successfully.');
    } catch (e) {
      print('Error updating StoreItem: $e');
    }
  }
}