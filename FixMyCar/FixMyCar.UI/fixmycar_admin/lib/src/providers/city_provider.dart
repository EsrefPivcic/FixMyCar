import 'package:fixmycar_admin/src/models/city/city.dart';
import 'package:fixmycar_admin/src/models/city/city_insert_update.dart';
import 'package:fixmycar_admin/src/models/search_result.dart';
import 'package:fixmycar_admin/src/providers/base_provider.dart';

class CityProvider extends BaseProvider<City, CityInsertUpdate> {
  List<City> cities = [];
  int countOfItems = 0;
  bool isLoading = false;

  CityProvider() : super('City');

  Future<void> getCities(
      {required int pageNumber, required int pageSize}) async {
    isLoading = true;
    notifyListeners();

    Map<String, dynamic> queryParams = {};
    queryParams['PageNumber'] = pageNumber.toString();
    queryParams['PageSize'] = pageSize.toString();

    try {
      SearchResult<City> searchResult = await get(
        filter: queryParams,
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

  Future<void> deleteCity(int id) async {
    await delete(
      id,
    );
  }

  Future<void> insertCity(CityInsertUpdate city) async {
    await insert(
      city,
      toJson: (city) => city.toJson(),
    );
  }

  Future<void> updateCity(int id, CityInsertUpdate city) async {
    await update(
      id: id,
      item: city,
      toJson: (city) => city.toJson(),
    );
  }
}
