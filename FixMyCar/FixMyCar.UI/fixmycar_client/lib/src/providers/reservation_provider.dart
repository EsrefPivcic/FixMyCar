import 'package:fixmycar_client/src/models/date_availability/date_availability.dart';
import 'package:fixmycar_client/src/models/reservation/reservation.dart';
import 'package:fixmycar_client/src/models/reservation/reservation_insert_update.dart';
import 'package:fixmycar_client/src/models/reservation/reservation_search_object.dart';
import 'package:fixmycar_client/src/models/search_result.dart';
import 'package:fixmycar_client/src/providers/base_provider.dart';
import 'package:fixmycar_client/src/utilities/custom_exception.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReservationProvider
    extends BaseProvider<Reservation, ReservationInsertUpdate> {
  List<Reservation> reservations = [];
  int countOfItems = 0;
  bool isLoading = false;

  ReservationProvider() : super('Reservation');

  Future<List<DateAvailability>> getAvailability({required int shopId}) async {
    notifyListeners();

    try {
      String url =
          '${BaseProvider.baseUrl}/$endpoint/GetShopAvailability?carRepairShopId=$shopId';
      final response = await http.get(
        Uri.parse(url),
        headers: await createHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseBody = jsonDecode(response.body);

        List<DateAvailability> availability = responseBody
            .map((item) => DateAvailability.fromJson(item))
            .toList()
            .cast<DateAvailability>();

        return availability;
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
      notifyListeners();
    }
  }

  Future<void> insertReservation(ReservationInsertUpdate reservation) async {
    try {
      final reservationResponse = await _createReservation(reservation);

      if (reservationResponse.statusCode != 200) {
        handleHttpError(reservationResponse);
        return;
      }

      final reservationResponseBody = jsonDecode(reservationResponse.body);

      int reservationId = reservationResponseBody['id'];
      double amount = reservationResponseBody['totalAmount'] is int
          ? (reservationResponseBody['totalAmount'] as int).toDouble()
          : reservationResponseBody['totalAmount'];

      int totalAmount = (amount * 100).toInt();

      final paymentIntentResponse =
          await _createPaymentIntent(reservationId, totalAmount);

      if (paymentIntentResponse.statusCode != 200) {
        handleHttpError(paymentIntentResponse);
        return;
      }

      final paymentIntentResponseBody = jsonDecode(paymentIntentResponse.body);

      final clientSecret = paymentIntentResponseBody['clientSecret'];
      final paymentIntentId = paymentIntentResponseBody['paymentIntentId'];

      try {
        await _confirmPayment(clientSecret);

        await _updatePaymentStatus(reservationId, paymentIntentId,
            successful: true);
        print('Payment successful');
      } catch (e) {
        print('Payment failed: $e');
        await _updatePaymentStatus(reservationId, paymentIntentId,
            successful: false);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> _createReservation(
      ReservationInsertUpdate reservation) async {
    final response = await http.post(
      Uri.parse('${BaseProvider.baseUrl}/$endpoint'),
      headers: await createHeaders(),
      body: jsonEncode(reservation),
    );
    return response;
  }

  Future<dynamic> _createPaymentIntent(
      int reservationId, int totalAmount) async {
    final response = await http.post(
      Uri.parse('${BaseProvider.baseUrl}/CreatePaymentIntent'),
      headers: await createHeaders(),
      body: jsonEncode(
          {'reservationId': reservationId, 'totalAmount': totalAmount}),
    );
    return response;
  }

  Future<void> _confirmPayment(String clientSecret) async {
    await Stripe.instance.confirmPayment(
      paymentIntentClientSecret: clientSecret,
      data: const PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData()),
      options: const PaymentMethodOptions(
        setupFutureUsage: PaymentIntentsFutureUsage.OffSession,
      ),
    );
  }

  Future<void> _updatePaymentStatus(int reservationId, String paymentIntentId,
      {required bool successful}) async {
    final endpointSuffix =
        successful ? 'AddSuccessfulPayment' : 'AddFailedPayment';
    final response = await http.put(
      Uri.parse(
          '${BaseProvider.baseUrl}/$endpoint/$endpointSuffix/$reservationId/$paymentIntentId'),
      headers: await createHeaders(),
    );

    if (response.statusCode != 200) {
      handleHttpError(response);
      return;
    }

    print(successful ? 'Payment status: successful' : 'Payment status: failed');
  }

  Future<void> updateReservation(
      int id, ReservationInsertUpdate reservationUpdate) async {
    await update(
        id: id,
        item: reservationUpdate,
        toJson: (reservationUpdate) => reservationUpdate.toJson());
  }

  Future<void> getByClient(
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
        customEndpoint: 'GetByClientToken',
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

  Future<void> addOrder(int id, int orderId) async {
    try {
      final response = await http.put(
          Uri.parse('${BaseProvider.baseUrl}/$endpoint/AddOrder/$id/$orderId'),
          headers: await createHeaders());
      if (response.statusCode == 200) {
        print('Adding order successful.');
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

  @override
  Future<void> delete(int id) async {
    try {
      final response = await http.put(
          Uri.parse('${BaseProvider.baseUrl}/$endpoint/SoftDelete/$id'),
          headers: await createHeaders());
      if (response.statusCode == 200) {
        print('Deleting reservation successful.');
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

  Future<void> cancel(int id) async {
    try {
      final response = await http.put(
          Uri.parse('${BaseProvider.baseUrl}/$endpoint/Cancel/$id'),
          headers: await createHeaders());
      if (response.statusCode == 200) {
        print('Cancelling reservation successful.');
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
