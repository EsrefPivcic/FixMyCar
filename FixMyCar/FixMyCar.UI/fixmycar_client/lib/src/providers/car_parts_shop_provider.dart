import 'package:fixmycar_client/src/models/user/user.dart';
import 'package:fixmycar_client/src/models/user/user_search_object.dart';
import 'package:fixmycar_client/src/providers/base_provider.dart';
import 'package:fixmycar_client/src/models/search_result.dart';

class CarPartsShopProvider extends BaseProvider<User, User> {
  CarPartsShopProvider() : super('CarPartsShop');

  int countOfItems = 0;
  List<User> carPartsShops = [];
  bool isLoading = false;

  Future<void> getPartsShops(
      {required int pageNumber,
      required int pageSize,
      UserSearchObject? search}) async {
    isLoading = true;
    notifyListeners();

    Map<String, dynamic> queryParams = {};

    queryParams['Active'] = true.toString();
    queryParams['PageNumber'] = pageNumber.toString();
    queryParams['PageSize'] = pageSize.toString();

    if (search != null) {
      if (search.containsUsername != null) {
        if (search.containsUsername!.isNotEmpty) {
          queryParams['ContainsUsername'] = search.containsUsername;
        }
      }
      if (search.cityId != null) {
        queryParams['CityId'] = search.cityId.toString();
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
