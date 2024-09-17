import 'package:fixmycar_admin/src/models/search_result.dart';
import 'package:fixmycar_admin/src/models/user/user.dart';
import 'package:fixmycar_admin/src/models/user/user_search_object.dart';
import 'package:fixmycar_admin/src/providers/base_provider.dart';

class CarPartsShopProvider extends BaseProvider<User, User> {
  CarPartsShopProvider() : super('CarPartsShop');

  int countOfItems = 0;
  List<User> carPartsShops = [];
  bool isLoading = false;

  Future<void> getPartsShops({UserSearchObject? search}) async {
    isLoading = true;
    notifyListeners();

    Map<String, dynamic> queryParams = {};

    if (search != null) {
      if (search.containsUsername != null) {
        if (search.containsUsername!.isNotEmpty) {
          queryParams['ContainsUsername'] = search.containsUsername;
        }
      }
    }
    
    try {
        SearchResult<User> searchResult = await get(
          filter: queryParams,
          fromJson: (json) => User.fromJson(json),
        );

        carPartsShops = searchResult.result;
        countOfItems = searchResult.count;
        isLoading = false;
      } catch (e) {
        carPartsShops = [];
        countOfItems = 0;
        isLoading = false;
      } finally {
        isLoading = false;
        notifyListeners();
      }
  }
}
