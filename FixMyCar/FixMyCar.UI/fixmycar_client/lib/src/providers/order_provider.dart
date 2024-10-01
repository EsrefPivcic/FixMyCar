import 'dart:convert';

import 'package:fixmycar_client/src/models/order/order.dart';
import 'package:fixmycar_client/src/models/order/order_insert_update.dart';
import 'package:fixmycar_client/src/models/order/order_search_object.dart';
import 'package:fixmycar_client/src/models/search_result.dart';
import 'package:fixmycar_client/src/providers/base_provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class OrderProvider extends BaseProvider<Order, OrderInsertUpdate> {
  List<Order> orders = [];
  int countOfItems = 0;
  bool isLoading = false;

  OrderProvider() : super('Order');

  Future<void> getByClient({OrderSearchObject? orderSearch}) async {
    isLoading = true;
    notifyListeners();

    Map<String, dynamic> queryParams = {};

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
        _handleError(orderResponse, step: 'Order creation');
        return;
      }

      final orderResponseBody = jsonDecode(orderResponse.body);

      int orderId = orderResponseBody['id'];
      double amount = orderResponseBody['totalAmount'] is int
          ? (orderResponseBody['totalAmount'] as int).toDouble()
          : orderResponseBody['totalAmount'];

      int totalAmount = (amount * 100).toInt();

      final paymentResponse = await _createPaymentIntent(orderId, totalAmount);

      final paymentResponseBody = jsonDecode(paymentResponse.body);

      final clientSecret = paymentResponseBody['clientSecret'];
      final paymentIntentId = paymentResponseBody['paymentIntentId'];

      try {
        await _confirmPayment(clientSecret);

        await _updatePaymentStatus(orderId, paymentIntentId, successful: true);
        print('Payment successful');
      } catch (e) {
        print('Payment failed: $e');
        await _updatePaymentStatus(orderId, paymentIntentId, successful: false);
      }
    } catch (e) {
      print('Error during order insertion: $e');
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
      Uri.parse('${BaseProvider.baseUrl}/ConfirmPayment'),
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
      throw Exception(
          'Failed to update payment status. Status code: ${response.statusCode}');
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
        throw Exception(
            'Failed to cancel the order. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error canceling the order: $e');
      rethrow;
    }
  }

  Future<void> resend(int id) async {
    try {
      final response = await http.put(
          Uri.parse('${BaseProvider.baseUrl}/$endpoint/Resend/$id'),
          headers: await createHeaders());
      if (response.statusCode == 200) {
        print('Resend successful.');
        notifyListeners();
      } else {
        throw Exception(
            'Failed to resend the order. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error resending the order: $e');
      rethrow;
    }
  }

  void _handleError(dynamic response, {required String step}) {
    final errors = response['errors'] as Map<String, dynamic>?;
    if (errors != null) {
      final userErrors = errors['UserError'] as List<dynamic>?;
      if (userErrors != null && userErrors.isNotEmpty) {
        throw Exception('$step failed. User error: ${userErrors.first}');
      } else {
        throw Exception(
            '$step failed. Server error: Status code ${response['statusCode']}');
      }
    } else {
      throw Exception(
          '$step failed. Unknown error: Status code ${response['statusCode']}');
    }
  }
}
