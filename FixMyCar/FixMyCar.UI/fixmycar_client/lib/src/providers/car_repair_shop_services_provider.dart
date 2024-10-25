import 'package:fixmycar_client/src/models/car_repair_shop_service/car_repair_shop_service.dart';
import 'package:fixmycar_client/src/models/car_repair_shop_service/car_repair_shop_service_search_object.dart';
import 'package:fixmycar_client/src/providers/base_provider.dart';
import 'package:fixmycar_client/src/models/search_result.dart';

class CarRepairShopServiceProvider
    extends BaseProvider<CarRepairShopService, CarRepairShopService> {
  List<CarRepairShopService> services = [];
  int countOfItems = 0;
  bool isLoading = false;

  CarRepairShopServiceProvider() : super('CarRepairShopService');

  Future<void> getByCarRepairShop(
      {required int pageNumber,
      required int pageSize,
      required String carRepairShopName,
      CarRepairShopServiceSearchObject? serviceSearch}) async {
    isLoading = true;
    notifyListeners();

    Map<String, dynamic> queryParams = {};

    queryParams['CarRepairShopName'] = carRepairShopName;
    queryParams['State'] = "active";
    queryParams['PageNumber'] = pageNumber.toString();
    queryParams['PageSize'] = pageSize.toString();

    if (serviceSearch != null) {
      if (serviceSearch.name != null) {
        if (serviceSearch.name!.isNotEmpty) {
          queryParams['Name'] = serviceSearch.name;
        }
      }

      if (serviceSearch.serviceType != null) {
        if (serviceSearch.serviceType!.isNotEmpty) {
          queryParams['ServiceType'] = serviceSearch.serviceType;
        }
      }

      if (serviceSearch.withDiscount != null) {
        queryParams['WithDiscount'] = serviceSearch.withDiscount.toString();
      }
    }

    try {
      SearchResult<CarRepairShopService> searchResult = await get(
        filter: queryParams,
        fromJson: (json) => CarRepairShopService.fromJson(json),
      );

      services = searchResult.result;
      countOfItems = searchResult.count;
      isLoading = false;

      notifyListeners();
    } catch (e) {
      services = [];
      countOfItems = 0;
      isLoading = false;

      notifyListeners();
    }
  }
}
