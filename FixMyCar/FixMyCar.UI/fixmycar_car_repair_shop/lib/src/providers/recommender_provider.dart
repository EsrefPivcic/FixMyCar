import 'package:fixmycar_car_repair_shop/src/models/store_item/store_item.dart';
import 'package:fixmycar_car_repair_shop/src/models/search_result.dart';
import 'package:fixmycar_car_repair_shop/src/providers/base_provider.dart';

class RecommenderProvider extends BaseProvider<StoreItem, StoreItem> {
  List<StoreItem> recommendedItems = [];
  int countOfItems = 0;
  bool isLoading = false;

  RecommenderProvider() : super('Recommender');

  Future<void> getRecommendations({
    required int storeItemId,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      SearchResult<StoreItem> searchResult = await get(
          customEndpoint: 'RecommendStoreItems/$storeItemId',
          fromJson: (json) => StoreItem.fromJson(json));

      recommendedItems = searchResult.result;
      countOfItems = searchResult.count;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      recommendedItems = [];
      countOfItems = 0;
      isLoading = false;
      notifyListeners();
    }
  }
}
