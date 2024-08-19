import 'package:fixmycar_car_repair_shop/src/models/service_type/service_type.dart';
import 'package:fixmycar_car_repair_shop/src/providers/base_provider.dart';
import 'package:fixmycar_car_repair_shop/src/models/search_result.dart';

class ServiceTypeProvider extends BaseProvider<ServiceType, ServiceType> {
  List<ServiceType> types = [];
  int countOfItems = 0;
  bool isLoading = false;

  ServiceTypeProvider() : super('ServiceType');

  Future<void> getTypes() async {
    isLoading = true;
    notifyListeners();

    try {
      SearchResult<ServiceType> searchResult = await get(
        fromJson: (json) => ServiceType.fromJson(json),
      );

      types = searchResult.result;
      countOfItems = searchResult.count;
      isLoading = false;

      notifyListeners();
    } catch (e) {
      types = [];
      countOfItems = 0;
      isLoading = false;

      notifyListeners();
    }
  }
}
