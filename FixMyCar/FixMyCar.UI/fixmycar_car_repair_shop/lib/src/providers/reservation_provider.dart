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

  Future<void> getByCarRepairShop({ReservationSearchObject? reservationSearch}) async {
    isLoading = true;
    notifyListeners();

    Map<String, dynamic> queryParams = {};

    if (reservationSearch != null) {
      if (reservationSearch.discount != null) {
        queryParams['Discount'] = reservationSearch.discount.toString();
      }
      if (reservationSearch.state != null) {
        if (reservationSearch.state!.isNotEmpty) {
          queryParams['State'] = reservationSearch.state;
        }
      }
      if (reservationSearch.minTotalAmount != null) {
        queryParams['MinTotalAmount'] = reservationSearch.minTotalAmount.toString();
      }
      if (reservationSearch.maxTotalAmount != null) {
        queryParams['MaxTotalAmount'] = reservationSearch.maxTotalAmount.toString();
      }
      if (reservationSearch.minCreatedDate != null) {
        queryParams['MinCreatedDate'] = reservationSearch.minCreatedDate.toString();
      }
      if (reservationSearch.maxCreatedDate != null) {
        queryParams['MaxCreatedDate'] = reservationSearch.maxCreatedDate.toString();
      }
      if (reservationSearch.minReservationDate != null) {
        queryParams['MinReservationDate'] = reservationSearch.minReservationDate.toString();
      }
      if (reservationSearch.maxReservationDate != null) {
        queryParams['MaxReservationDate'] = reservationSearch.maxReservationDate.toString();
      }
      if (reservationSearch.minCompletionDate != null) {
        queryParams['MinCompletionDate'] = reservationSearch.minCompletionDate.toString();
      }
      if (reservationSearch.maxCompletionDate != null) {
        queryParams['MaxCompletionDate'] = reservationSearch.maxCompletionDate.toString();
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

  Future<void> accept(int id) async {
    try {
      final response = await http.put(
          Uri.parse('${BaseProvider.baseUrl}/$endpoint/Accept/$id'),
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
}
