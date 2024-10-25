import 'package:fixmycar_car_repair_shop/src/models/reservation/reservation.dart';
import 'package:fixmycar_car_repair_shop/src/models/reservation/reservation_search_object.dart';
import 'package:fixmycar_car_repair_shop/src/models/search_result.dart';
import 'package:fixmycar_car_repair_shop/src/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReservationProvider extends BaseProvider<Reservation, Reservation> {
  List<Reservation> reservations = [];
  int countOfItems = 0;
  bool isLoading = false;

  ReservationProvider() : super('Reservation');

  Future<void> getByCarRepairShop(
      {required int pageNumber,
      required int pageSize,
      ReservationSearchObject? reservationSearch}) async {
    isLoading = true;
    notifyListeners();

    Map<String, dynamic> queryParams = {};

    queryParams['PageNumber'] = pageNumber.toString();
    queryParams['PageSize'] = pageSize.toString();

    if (reservationSearch != null) {
      if (reservationSearch.discount != null) {
        queryParams['Discount'] = reservationSearch.discount.toString();
      }
      if (reservationSearch.clientOrder != null) {
        queryParams['ClientOrder'] = reservationSearch.clientOrder.toString();
      }
      if (reservationSearch.state != null) {
        if (reservationSearch.state!.isNotEmpty) {
          queryParams['State'] = reservationSearch.state;
        }
      }
      if (reservationSearch.type != null) {
        if (reservationSearch.type!.isNotEmpty) {
          queryParams['Type'] = reservationSearch.type;
        }
      }
      if (reservationSearch.minTotalAmount != null) {
        queryParams['MinTotalAmount'] =
            reservationSearch.minTotalAmount.toString();
      }
      if (reservationSearch.maxTotalAmount != null) {
        queryParams['MaxTotalAmount'] =
            reservationSearch.maxTotalAmount.toString();
      }
      if (reservationSearch.minCreatedDate != null) {
        queryParams['MinCreatedDate'] =
            reservationSearch.minCreatedDate.toString();
      }
      if (reservationSearch.maxCreatedDate != null) {
        queryParams['MaxCreatedDate'] =
            reservationSearch.maxCreatedDate.toString();
      }
      if (reservationSearch.minReservationDate != null) {
        queryParams['MinReservationDate'] =
            reservationSearch.minReservationDate.toString();
      }
      if (reservationSearch.maxReservationDate != null) {
        queryParams['MaxReservationDate'] =
            reservationSearch.maxReservationDate.toString();
      }
      if (reservationSearch.minEstimatedCompletionDate != null) {
        queryParams['MinEstimatedCompletionDate'] =
            reservationSearch.minEstimatedCompletionDate.toString();
      }
      if (reservationSearch.maxEstimatedCompletionDate != null) {
        queryParams['MaxEstimatedCompletionDate'] =
            reservationSearch.maxEstimatedCompletionDate.toString();
      }
      if (reservationSearch.minCompletionDate != null) {
        queryParams['MinCompletionDate'] =
            reservationSearch.minCompletionDate.toString();
      }
      if (reservationSearch.maxCompletionDate != null) {
        queryParams['MaxCompletionDate'] =
            reservationSearch.maxCompletionDate.toString();
      }
    }

    try {
      SearchResult<Reservation> searchResult = await get(
        customEndpoint: 'GetByCarRepairShop',
        filter: queryParams,
        fromJson: (json) => Reservation.fromJson(json),
      );

      reservations = searchResult.result;
      countOfItems = searchResult.count;
      isLoading = false;

      notifyListeners();
    } catch (e) {
      reservations = [];
      countOfItems = 0;
      isLoading = false;

      notifyListeners();
    }
  }

  Future<void> accept(int id, String estimatedCompletionDate) async {
    try {
      final response = await http.put(
          Uri.parse(
              '${BaseProvider.baseUrl}/$endpoint/Accept/$id/$estimatedCompletionDate'),
          headers: await createHeaders());
      if (response.statusCode == 200) {
        print('Accepting reservation successful.');
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

  Future<void> addOrder(int id, int orderId) async {
    try {
      final response = await http.put(
          Uri.parse('${BaseProvider.baseUrl}/$endpoint/AddOrder/$id/$orderId'),
          headers: await createHeaders());
      if (response.statusCode == 200) {
        print('Adding order successful.');
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

  Future<void> complete(int id) async {
    try {
      final response = await http.put(
          Uri.parse('${BaseProvider.baseUrl}/$endpoint/Complete/$id'),
          headers: await createHeaders());
      if (response.statusCode == 200) {
        print('Completing reservation successful.');
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

  Future<void> start(int id) async {
    try {
      final response = await http.put(
          Uri.parse('${BaseProvider.baseUrl}/$endpoint/Start/$id'),
          headers: await createHeaders());
      if (response.statusCode == 200) {
        print('Reservation started successfully.');
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

  Future<void> reject(int id) async {
    try {
      final response = await http.put(
          Uri.parse('${BaseProvider.baseUrl}/$endpoint/Reject/$id'),
          headers: await createHeaders());
      if (response.statusCode == 200) {
        print('Rejecting reservation successful.');
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

  Future<void> delete(int id) async {
    try {
      final response = await http.put(
          Uri.parse('${BaseProvider.baseUrl}/$endpoint/SoftDelete/$id'),
          headers: await createHeaders());
      if (response.statusCode == 200) {
        print('Deleting reservation successful.');
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
