import 'dart:convert';

import 'package:fixmycar_client/src/models/order/order.dart';
import 'package:fixmycar_client/src/models/order/order_insert_update.dart';
import 'package:fixmycar_client/src/models/order/order_search_object.dart';
import 'package:fixmycar_client/src/models/search_result.dart';
import 'package:fixmycar_client/src/providers/base_provider.dart';
import 'package:fixmycar_client/src/utilities/custom_exception.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class OrderProvider extends BaseProvider<Order, OrderInsertUpdate> {
  List<Order> orders = [];
  int countOfItems = 0;
  bool isLoading = false;

  OrderProvider() : super('Order');

  Future<void> getByClient(
      {required int pageNumber,
      required int pageSize,
      OrderSearchObject? orderSearch}) async {
    isLoading = true;
    notifyListeners();

    Map<String, dynamic> queryParams = {};

    queryParams['PageNumber'] = pageNumber.toString();
    queryParams['PageSize'] = pageSize.toString();

    if (orderSearch != null) {
      if (orderSearch.discount != null) {
        queryParams['Discount'] = orderSearch.discount.toString();
      }
      if (orderSearch.state != null) {
        if (orderSearch.state!.isNotEmpty) {
          queryParams['State'] = orderSearch.state;
        }
      }
      if (orderSearch.minTotalAmount != null) {
        queryParams['MinTotalAmount'] = orderSearch.minTotalAmount.toString();
      }
      if (orderSearch.maxTotalAmount != null) {
        queryParams['MaxTotalAmount'] = orderSearch.maxTotalAmount.toString();
      }
      if (orderSearch.minOrderDate != null) {
        queryParams['MinOrderDate'] = orderSearch.minOrderDate.toString();
      }
      if (orderSearch.maxOrderDate != null) {
        queryParams['MaxOrderDate'] = orderSearch.maxOrderDate.toString();
      }
      if (orderSearch.minShippingDate != null) {
        queryParams['MinShippingDate'] = orderSearch.minShippingDate.toString();
      }
      if (orderSearch.maxShippingDate != null) {
        queryParams['MaxShippingDate'] = orderSearch.maxShippingDate.toString();
      }
    }

    try {
      SearchResult<Order> searchResult = await get(
        customEndpoint: 'GetByClient',
        filter: queryParams,
        fromJson: (json) => Order.fromJson(json),
      );

      orders = searchResult.result;
      countOfItems = searchResult.count;
      isLoading = false;

      notifyListeners();
    } catch (e) {
      orders = [];
      countOfItems = 0;
      isLoading = false;

      notifyListeners();
    }
  }

  Future<void> insertOrder(OrderInsertUpdate order) async {
    try {
      final orderResponse = await _createOrder(order);

      if (orderResponse.statusCode != 200) {
        handleHttpError(orderResponse);
        return;
      }

      final orderResponseBody = jsonDecode(orderResponse.body);

      int orderId = orderResponseBody['id'];
      double amount = orderResponseBody['totalAmount'] is int
          ? (orderResponseBody['totalAmount'] as int).toDouble()
          : orderResponseBody['totalAmount'];

      int totalAmount = (amount * 100).toInt();

      final paymentIntentResponse =
          await _createPaymentIntent(orderId, totalAmount);

      if (paymentIntentResponse.statusCode != 200) {
        handleHttpError(paymentIntentResponse);
        return;
      }

      final paymentIntentResponseBody = jsonDecode(paymentIntentResponse.body);

      final clientSecret = paymentIntentResponseBody['clientSecret'];
      final paymentIntentId = paymentIntentResponseBody['paymentIntentId'];

      try {
        await _confirmPayment(clientSecret);

        await _updatePaymentStatus(orderId, paymentIntentId, successful: true);
        print('Payment successful');
      } catch (e) {
        print('Payment failed: $e');
        await _updatePaymentStatus(orderId, paymentIntentId, successful: false);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> _createOrder(OrderInsertUpdate order) async {
    final response = await http.post(
      Uri.parse('${BaseProvider.baseUrl}/$endpoint'),
      headers: await createHeaders(),
      body: jsonEncode(order),
    );
    return response;
  }

  Future<dynamic> _createPaymentIntent(int orderId, int totalAmount) async {
    final response = await http.post(
      Uri.parse('${BaseProvider.baseUrl}/CreatePaymentIntent'),
      headers: await createHeaders(),
      body: jsonEncode({'orderId': orderId, 'totalAmount': totalAmount}),
    );
    return response;
  }

  Future<void> _confirmPayment(String clientSecret) async {
    await Stripe.instance.confirmPayment(
      paymentIntentClientSecret: clientSecret,
      data: const PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData()),
    );
  }

  Future<void> _updatePaymentStatus(int orderId, String paymentIntentId,
      {required bool successful}) async {
    final endpointSuffix =
        successful ? 'AddSuccessfulPayment' : 'AddFailedPayment';
    final response = await http.put(
      Uri.parse(
          '${BaseProvider.baseUrl}/$endpoint/$endpointSuffix/$orderId/$paymentIntentId'),
      headers: await createHeaders(),
    );

    if (response.statusCode != 200) {
      handleHttpError(response);
      return;
    }

    print(successful ? 'Payment status: successful' : 'Payment status: failed');
  }

  Future<void> updateOrder(int id, OrderInsertUpdate orderUpdate) async {
    await update(
        id: id,
        item: orderUpdate,
        toJson: (orderUpdate) => orderUpdate.toJson());
  }

  Future<void> cancel(int id) async {
    try {
      final response = await http.put(
          Uri.parse('${BaseProvider.baseUrl}/$endpoint/Cancel/$id'),
          headers: await createHeaders());
      if (response.statusCode == 200) {
        print('Cancel successful.');
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
        print('Delete successful.');
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
