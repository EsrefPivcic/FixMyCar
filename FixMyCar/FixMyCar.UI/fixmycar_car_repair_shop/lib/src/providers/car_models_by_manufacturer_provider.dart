import 'package:fixmycar_car_repair_shop/src/models/search_result.dart';
import 'package:fixmycar_car_repair_shop/src/providers/base_provider.dart';
import 'package:fixmycar_car_repair_shop/src/models/car_model/car_models_by_manufacturer.dart';

class CarModelsByManufacturerProvider extends BaseProvider<CarModelsByManufacturer, CarModelsByManufacturer> {
  List<CarModelsByManufacturer> modelsByManufacturer = [];
  int countOfItems = 0;
  bool isLoading = false;

  CarModelsByManufacturerProvider() : super('GetByManufacturerAll');

  Future<void> getCarModelsByManufacturer() async {
    isLoading = true;
    notifyListeners();

    try {
      SearchResult<CarModelsByManufacturer> searchResult = await get(
        fromJson: (json) => CarModelsByManufacturer.fromJson(json),
      );

      modelsByManufacturer = searchResult.result;
      countOfItems = searchResult.count;
      isLoading = false;

      notifyListeners();
    } catch (e) {
      modelsByManufacturer = [];
      countOfItems = 0;
      isLoading = false;
      
      notifyListeners();
    }
  }
}