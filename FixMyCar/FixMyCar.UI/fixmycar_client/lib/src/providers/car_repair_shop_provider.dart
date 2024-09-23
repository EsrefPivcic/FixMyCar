import 'package:fixmycar_client/src/models/user/user.dart';
import 'package:fixmycar_client/src/models/user/user_search_object.dart';
import 'package:fixmycar_client/src/providers/base_provider.dart';
import 'package:fixmycar_client/src/models/search_result.dart';

class CarRepairShopProvider extends BaseProvider<User, User> {
  CarRepairShopProvider() : super('CarRepairShop');

  int countOfItems = 0;
  List<User> carRepairShops = [];
  bool isLoading = false;

  Future<void> getRepairShops({UserSearchObject? search}) async {
    isLoading = true;
    notifyListeners();

    Map<String, dynamic> queryParams = {};

    queryParams['Active'] = true.toString();

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

        carRepairShops = searchResult.result;
        countOfItems = searchResult.count;
        isLoading = false;
      } catch (e) {
        carRepairShops = [];
        countOfItems = 0;
        isLoading = false;
      } finally {
        isLoading = false;
        notifyListeners();
      }
  }
}
