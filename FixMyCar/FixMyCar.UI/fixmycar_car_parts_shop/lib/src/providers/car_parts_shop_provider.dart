import 'package:fixmycar_car_parts_shop/src/models/report_filter/report_filter.dart';
import 'package:fixmycar_car_parts_shop/src/models/user/user.dart';
import 'package:fixmycar_car_parts_shop/src/models/user/user_update_work_details.dart';
import 'package:fixmycar_car_parts_shop/src/models/user/user_register.dart';
import 'package:fixmycar_car_parts_shop/src/models/search_result.dart';
import 'package:fixmycar_car_parts_shop/src/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CarPartsShopProvider extends BaseProvider<User, UserRegister> {
  CarPartsShopProvider() : super('CarPartsShop');

  User? user;
  bool isLoading = false;
  bool isLoadingReport = false;

  Future<void> insertUser(UserRegister user) async {
    await insert(
      user,
      customEndpoint: 'InsertCarPartsShop',
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
        print('Failed to load report. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching report: $e');
      return null;
    } finally {
      isLoadingReport = false;
    }
  }

  Future<String?> getMonthlyRevenuePerCustomerTypeReport() async {
    try {
      isLoadingReport = true;
      final response = await http.get(
        Uri.parse(
            '${BaseProvider.baseUrl}/$endpoint/GetMonthlyRevenuePerCustomerTypeReport'),
        headers: await createHeaders(),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('Failed to load report. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching report: $e');
      return null;
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
        print('Failed to load report. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching report: $e');
      return null;
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
        print('Failed to load report. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching report: $e');
      return null;
    } finally {
      isLoadingReport = false;
    }
  }

  Future<String?> getTop10OrdersMonthlyReport() async {
    try {
      isLoadingReport = true;
      final response = await http.get(
        Uri.parse(
            '${BaseProvider.baseUrl}/$endpoint/GetTop10OrdersMonthlyReport'),
        headers: await createHeaders(),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('Failed to load report. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching report: $e');
      return null;
    } finally {
      isLoadingReport = false;
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
        final responseBody = jsonDecode(response.body);
        final errors = responseBody['errors'] as Map<String, dynamic>?;

        if (errors != null) {
          final userErrors = errors['UserError'] as List<dynamic>?;
          if (userErrors != null) {
            for (var error in userErrors) {
              throw Exception(
                  'User error. $error Status code: ${response.statusCode}');
            }
          } else {
            throw Exception(
                'Server side error. Status code: ${response.statusCode}');
          }
        } else {
          throw Exception('Unknown error. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      rethrow;
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
        final responseBody = jsonDecode(response.body);
        final errors = responseBody['errors'] as Map<String, dynamic>?;

        if (errors != null) {
          final userErrors = errors['UserError'] as List<dynamic>?;
          if (userErrors != null) {
            for (var error in userErrors) {
              throw Exception(
                  'User error. $error Status code: ${response.statusCode}');
            }
          } else {
            throw Exception(
                'Server side error. Status code: ${response.statusCode}');
          }
        } else {
          throw Exception('Unknown error. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      rethrow;
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
        final responseBody = jsonDecode(response.body);
        final errors = responseBody['errors'] as Map<String, dynamic>?;

        if (errors != null) {
          final userErrors = errors['UserError'] as List<dynamic>?;
          if (userErrors != null) {
            for (var error in userErrors) {
              throw Exception(
                  'User error. $error Status code: ${response.statusCode}');
            }
          } else {
            throw Exception(
                'Server side error. Status code: ${response.statusCode}');
          }
        } else {
          throw Exception('Unknown error. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
