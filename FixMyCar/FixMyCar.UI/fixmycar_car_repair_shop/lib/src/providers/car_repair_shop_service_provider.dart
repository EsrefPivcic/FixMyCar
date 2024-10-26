import 'package:fixmycar_car_repair_shop/src/models/car_repair_shop_service/car_repair_shop_service.dart';
import 'package:fixmycar_car_repair_shop/src/models/car_repair_shop_service/car_repair_shop_service_insert_update.dart';
import 'package:fixmycar_car_repair_shop/src/models/car_repair_shop_service/car_repair_shop_service_search_object.dart';
import 'package:fixmycar_car_repair_shop/src/providers/base_provider.dart';
import 'package:fixmycar_car_repair_shop/src/models/search_result.dart';
import 'package:fixmycar_car_repair_shop/src/utilities/custom_exception.dart';
import 'package:http/http.dart' as http;

class CarRepairShopServiceProvider extends BaseProvider<CarRepairShopService,
    CarRepairShopServiceInsertUpdate> {
  List<CarRepairShopService> services = [];
  int countOfItems = 0;
  bool isLoading = false;

  CarRepairShopServiceProvider() : super('CarRepairShopService');

  Future<void> getByCarRepairShop(
      {required int pageNumber,
      required int pageSize,
      CarRepairShopServiceSearchObject? serviceSearch}) async {
    isLoading = true;
    notifyListeners();

    Map<String, dynamic> queryParams = {};

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

      if (serviceSearch.state != null) {
        if (serviceSearch.state!.isNotEmpty) {
          queryParams['State'] = serviceSearch.state;
        }
      }
    }

    try {
      SearchResult<CarRepairShopService> searchResult = await get(
        customEndpoint: 'GetByCarRepairShop',
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

  Future<void> deleteService(int id) async {
    await delete(
      id,
    );
  }

  Future<void> insertService(CarRepairShopServiceInsertUpdate service) async {
    await insert(
      service,
      toJson: (service) => service.toJson(),
    );
  }

  Future<void> updateService(
      int id, CarRepairShopServiceInsertUpdate service) async {
    await update(
      id: id,
      item: service,
      toJson: (service) => service.toJson(),
    );
  }

  Future<void> activate(int id) async {
    try {
      final response = await http.put(
        Uri.parse('${BaseProvider.baseUrl}/$endpoint/$id/Activate'),
        headers: await createHeaders(),
      );
      if (response.statusCode == 200) {
        print('Activation successful.');
        notifyListeners();
      } else {
        handleHttpError(response);
      }
    } on CustomException {
      rethrow;
    } catch (e) {
      throw CustomException(
          "Can't reach the server. Please check your internet connection.");
    }
  }

  Future<void> hide(int id) async {
    try {
      final response = await http.put(
        Uri.parse('${BaseProvider.baseUrl}/$endpoint/$id/Hide'),
        headers: await createHeaders(),
      );
      if (response.statusCode == 200) {
        print('Hiding successful.');
        notifyListeners();
      } else {
        handleHttpError(response);
      }
    } on CustomException {
      rethrow;
    } catch (e) {
      throw CustomException(
          "Can't reach the server. Please check your internet connection.");
    }
  }
}
