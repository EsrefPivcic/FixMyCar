import 'package:fixmycar_car_parts_shop/src/models/search_result.dart';
import 'package:fixmycar_car_parts_shop/src/providers/base_provider.dart';
import 'package:fixmycar_car_parts_shop/src/models/car_parts_shop_client_discount/car_parts_shop_client_discount.dart';
import 'package:fixmycar_car_parts_shop/src/models/car_parts_shop_client_discount/car_parts_shop_client_discount_insert_update.dart';
import 'package:fixmycar_car_parts_shop/src/utilities/custom_exception.dart';
import 'package:http/http.dart' as http;

class CarPartsShopClientDiscountProvider extends BaseProvider<
    CarPartsShopClientDiscount, CarPartsShopClientDiscountInsertUpdate> {
  List<CarPartsShopClientDiscount> discounts = [];
  int countOfItems = 0;
  bool isLoading = false;

  CarPartsShopClientDiscountProvider() : super('CarPartsShopClientDiscount');

  Future<void> getByCarPartsShop(
      {required int pageNumber,
      required int pageSize,
      String? role,
      bool? active}) async {
    isLoading = true;
    notifyListeners();

    Map<String, dynamic> queryParams = {};

    queryParams['PageNumber'] = pageNumber.toString();
    queryParams['PageSize'] = pageSize.toString();

    if (role != null && role.isNotEmpty) {
      queryParams['Role'] = role;
    }
    if (active != null) {
      queryParams['Active'] = active.toString();
    }

    try {
      SearchResult<CarPartsShopClientDiscount> searchResult = await get(
        customEndpoint: 'GetByCarPartsShop',
        filter: queryParams,
        fromJson: (json) => CarPartsShopClientDiscount.fromJson(json),
      );

      discounts = searchResult.result;
      countOfItems = searchResult.count;
      isLoading = false;

      notifyListeners();
    } catch (e) {
      discounts = [];
      countOfItems = 0;
      isLoading = false;

      notifyListeners();
    }
  }

  Future<void> updateDiscount(
      int id, CarPartsShopClientDiscountInsertUpdate discount) async {
    await update(
        id: id, item: discount, toJson: (storeItem) => storeItem.toJson());
  }

  @override
  Future<void> delete(int id) async {
    try {
      final response = await http.put(
          Uri.parse('${BaseProvider.baseUrl}/$endpoint/SoftDelete/$id'),
          headers: await createHeaders());
      if (response.statusCode == 200) {
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

  Future<void> insertDiscount(
      CarPartsShopClientDiscountInsertUpdate discount) async {
    await insert(
      discount,
      toJson: (storeItem) => storeItem.toJson(),
    );
  }
}
