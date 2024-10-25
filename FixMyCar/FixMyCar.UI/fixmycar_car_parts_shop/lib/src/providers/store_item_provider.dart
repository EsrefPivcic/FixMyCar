import 'package:fixmycar_car_parts_shop/src/models/store_item/store_item.dart';
import 'package:fixmycar_car_parts_shop/src/models/search_result.dart';
import 'package:fixmycar_car_parts_shop/src/models/store_item/store_item_insert_update.dart';
import 'package:fixmycar_car_parts_shop/src/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class StoreItemProvider extends BaseProvider<StoreItem, StoreItemInsertUpdate> {
  List<StoreItem> items = [];
  int countOfItems = 0;
  bool isLoading = false;

  StoreItemProvider() : super('StoreItem');

  Future<void> getStoreItems({
    required int pageNumber,
    required int pageSize,
    String? nameFilter,
    bool? withDiscount,
    String? state,
    int? categoryFilter,
    List<int>? carModelsFilter,
  }) async {
    isLoading = true;
    notifyListeners();

    Map<String, dynamic> queryParams = {};

    queryParams['PageNumber'] = pageNumber.toString();
    queryParams['PageSize'] = pageSize.toString();

    if (nameFilter != null && nameFilter.isNotEmpty) {
      queryParams['Contains'] = nameFilter;
    }
    if (withDiscount != null) {
      queryParams['WithDiscount'] = withDiscount.toString();
    }
    if (state != null && state.isNotEmpty) {
      queryParams['State'] = state;
    }
    if (categoryFilter != null) {
      queryParams['StoreItemCategoryId'] = categoryFilter.toString();
    }
    if (carModelsFilter != null && carModelsFilter.isNotEmpty) {
      queryParams['CarModelIds'] =
          carModelsFilter.map((carModel) => carModel.toString()).toList();
    }

    try {
      SearchResult<StoreItem> searchResult = await get(
          filter: queryParams,
          fromJson: (json) => StoreItem.fromJson(json),
          customEndpoint: 'GetByToken');

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

  Future<void> updateStoreItem(int id, StoreItemInsertUpdate storeitem) async {
    await update(
      id: id,
      item: storeitem,
      toJson: (storeItem) => storeItem.toJson(),
    );
  }

  Future<void> insertStoreItem(StoreItemInsertUpdate storeitem) async {
    await insert(
      storeitem,
      toJson: (storeItem) => storeItem.toJson(),
    );
  }

  Future<void> deleteStoreItem(int id) async {
    await delete(
      id,
    );
  }

  Future<void> activate(int id) async {
    try {
      final response = await http.put(
        Uri.parse('${BaseProvider.baseUrl}/StoreItem/$id/Activate'),
        headers: await createHeaders(),
      );
      if (response.statusCode == 200) {
        print('Activation successful.');
        notifyListeners();
      } else {
        throw Exception(
            'Failed to activate the item. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error activating the item: $e');
      rethrow;
    }
  }

  Future<void> hide(int id) async {
    try {
      final response = await http.put(
        Uri.parse('${BaseProvider.baseUrl}/StoreItem/$id/Hide'),
        headers: await createHeaders(),
      );
      if (response.statusCode == 200) {
        print('Hiding successful.');
        notifyListeners();
      } else {
        throw Exception(
            'Failed to hide the item. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error hiding the item: $e');
      rethrow;
    }
  }
}
