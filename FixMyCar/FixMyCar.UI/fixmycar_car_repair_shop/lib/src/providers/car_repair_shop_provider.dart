import 'package:fixmycar_car_repair_shop/src/models/report_filter/report_filter.dart';
import 'package:fixmycar_car_repair_shop/src/models/user/user.dart';
import 'package:fixmycar_car_repair_shop/src/models/user/user_register.dart';
import 'package:fixmycar_car_repair_shop/src/models/user/user_update_work_details.dart';
import 'package:fixmycar_car_repair_shop/src/providers/base_provider.dart';
import 'package:fixmycar_car_repair_shop/src/models/search_result.dart';
import 'package:fixmycar_car_repair_shop/src/utilities/custom_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CarRepairShopProvider extends BaseProvider<User, UserRegister> {
  CarRepairShopProvider() : super('CarRepairShop');

  User? user;
  bool isLoading = false;
  bool isLoadingReport = false;

  Future<void> insertUser(UserRegister user) async {
    await insert(
      user,
      customEndpoint: 'InsertCarRepairShop',
      toJson: (user) => user.toJson(),
    );
  }

  Future<void> getByToken() async {
    isLoading = true;
    notifyListeners();

    try {
      SearchResult<User> searchResult = await get(
        customEndpoint: 'GetByToken',
        fromJson: (json) => User.fromJson(json),
      );

      user = searchResult.result[0];
    } catch (e) {
      user = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> getReport() async {
    try {
      isLoadingReport = true;
      final response = await http.get(
        Uri.parse('${BaseProvider.baseUrl}/$endpoint/GetReport'),
        headers: await createHeaders(),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        handleHttpError(response);
        throw CustomException('Unhandled HTTP error');
      }
    } on CustomException {
      rethrow;
    } catch (e) {
      throw CustomException(
          "Can't reach the server. Please check your internet connection.");
    } finally {
      isLoadingReport = false;
    }
  }

  Future<String?> getMonthlyRevenuePerReservationTypeReport() async {
    try {
      isLoadingReport = true;
      final response = await http.get(
        Uri.parse(
            '${BaseProvider.baseUrl}/$endpoint/GetMonthlyRevenuePerReservationTypeReport'),
        headers: await createHeaders(),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        handleHttpError(response);
        throw CustomException('Unhandled HTTP error');
      }
    } on CustomException {
      rethrow;
    } catch (e) {
      throw CustomException(
          "Can't reach the server. Please check your internet connection.");
    } finally {
      isLoadingReport = false;
    }
  }

  Future<String?> getMonthlyRevenuePerDayReport() async {
    try {
      isLoadingReport = true;
      final response = await http.get(
        Uri.parse(
            '${BaseProvider.baseUrl}/$endpoint/GetMonthlyRevenuePerDayReport'),
        headers: await createHeaders(),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        handleHttpError(response);
        throw CustomException('Unhandled HTTP error');
      }
    } on CustomException {
      rethrow;
    } catch (e) {
      throw CustomException(
          "Can't reach the server. Please check your internet connection.");
    } finally {
      isLoadingReport = false;
    }
  }

  Future<String?> getTop10CustomersMonthlyReport() async {
    try {
      isLoadingReport = true;
      final response = await http.get(
        Uri.parse(
            '${BaseProvider.baseUrl}/$endpoint/GetTop10CustomersMonthlyReport'),
        headers: await createHeaders(),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        handleHttpError(response);
        throw CustomException('Unhandled HTTP error');
      }
    } on CustomException {
      rethrow;
    } catch (e) {
      throw CustomException(
          "Can't reach the server. Please check your internet connection.");
    } finally {
      isLoadingReport = false;
    }
  }

  Future<String?> getTop10ReservationsMonthlyReport() async {
    try {
      isLoadingReport = true;
      final response = await http.get(
        Uri.parse(
            '${BaseProvider.baseUrl}/$endpoint/GetTop10ReservationsMonthlyReport'),
        headers: await createHeaders(),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        handleHttpError(response);
        throw CustomException('Unhandled HTTP error');
      }
    } on CustomException {
      rethrow;
    } catch (e) {
      throw CustomException(
          "Can't reach the server. Please check your internet connection.");
    } finally {
      isLoadingReport = false;
    }
  }

  Future<void> updateMonthlyStatistics() async {
    try {
      final response = await http.post(
        Uri.parse('${BaseProvider.baseUrl}/$endpoint/GenerateMonthlyReport'),
        headers: await createHeaders(),
      );

      if (response.statusCode == 200) {
        print('Request successful.');
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

  Future<void> generateReport({required ReportFilter filter}) async {
    try {
      final response = await http.post(
        Uri.parse('${BaseProvider.baseUrl}/$endpoint/GenerateReport'),
        headers: await createHeaders(),
        body: jsonEncode(filter),
      );

      if (response.statusCode == 200) {
        print('Request successful.');
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

  Future<void> updateWorkDetails(
      {required UserUpdateWorkDetails updateWorkDetails}) async {
    toJson(UserUpdateWorkDetails updateWorkDetails) =>
        updateWorkDetails.toJson();
    try {
      final response = await http.put(
        Uri.parse('${BaseProvider.baseUrl}/$endpoint/UpdateWorkDetailsByToken'),
        headers: await createHeaders(),
        body: jsonEncode(toJson(updateWorkDetails)),
      );
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
}
