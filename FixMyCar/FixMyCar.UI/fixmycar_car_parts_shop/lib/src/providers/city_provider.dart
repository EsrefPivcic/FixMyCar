import 'package:fixmycar_car_parts_shop/src/models/city/city.dart';
import 'package:fixmycar_car_parts_shop/src/models/search_result.dart';
import 'package:fixmycar_car_parts_shop/src/providers/base_provider.dart';

class CityProvider extends BaseProvider<City, City> {
  List<City> cities = [];
  int countOfItems = 0;
  bool isLoading = false;

  CityProvider() : super('City');

  Future<void> getCities() async {
    isLoading = true;
    notifyListeners();
    try {
      SearchResult<City> searchResult = await get(
        fromJson: (json) => City.fromJson(json),
      );

      cities = searchResult.result;
      countOfItems = searchResult.count;
      isLoading = false;

      notifyListeners();
    } catch (e) {
      cities = [];
      countOfItems = 0;
      isLoading = false;
      notifyListeners();
    }
  }
}
