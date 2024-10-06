import 'package:fixmycar_client/src/models/car_repair_shop_service/car_repair_shop_service.dart';
import 'package:fixmycar_client/src/models/search_result.dart';
import 'package:fixmycar_client/src/providers/base_provider.dart';

class ServicesRecommenderProvider
    extends BaseProvider<CarRepairShopService, CarRepairShopService> {
  List<CarRepairShopService> recommendedServices = [];
  int countOfServices = 0;
  bool isLoading = false;

  ServicesRecommenderProvider() : super('Recommender');

  Future<void> getServicesRecommendations({
    required int carRepairShopServiceId,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      SearchResult<CarRepairShopService> searchResult = await get(
          customEndpoint: 'RecommendRepairShopServices/$carRepairShopServiceId',
          fromJson: (json) => CarRepairShopService.fromJson(json));

      recommendedServices = searchResult.result;
      countOfServices = searchResult.count;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      recommendedServices = [];
      countOfServices = 0;
      isLoading = false;
      notifyListeners();
    }
  }
}
