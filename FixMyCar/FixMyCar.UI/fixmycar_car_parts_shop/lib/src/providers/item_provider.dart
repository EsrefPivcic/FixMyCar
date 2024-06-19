import 'package:fixmycar_car_parts_shop/src/models/item/item.dart';
import 'package:fixmycar_car_parts_shop/src/models/search_result.dart';
import 'package:fixmycar_car_parts_shop/src/providers/base_provider.dart';

class ItemProvider extends BaseProvider<Item> {
  List<Item> items = [];
  int countOfItems = 0;
  bool isLoading = false;

  ItemProvider() : super('Product');

  Future<void> getItems({
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
      SearchResult<Item> searchResult = await get(
        filter: queryParams,
        fromJson: (json) => Item.fromJson(json),
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
}
