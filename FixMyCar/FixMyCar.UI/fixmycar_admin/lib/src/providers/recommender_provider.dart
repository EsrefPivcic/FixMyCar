import 'dart:convert';
import 'package:fixmycar_admin/src/utilities/custom_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RecommenderProvider with ChangeNotifier {
  static const String baseUrl = 'https://localhost:7055';
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<Map<String, String>> createHeaders() async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final String? token = await storage.read(key: 'jwt_token');
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<void> trainOrdersModel() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Recommender/TrainOrdersModel'),
        headers: await createHeaders(),
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

  Future<void> trainReservationsModel() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Recommender/TrainReservationsModel'),
        headers: await createHeaders(),
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

  void handleHttpError(http.Response response) {
    if (response.statusCode != 200) {
      final responseBody = jsonDecode(response.body);
      final errors = responseBody['errors'] as Map<String, dynamic>?;

      if (errors != null) {
        final userErrors = errors['UserError'] as List<dynamic>?;
        if (userErrors != null) {
          for (var error in userErrors) {
            throw CustomException('$error');
          }
        } else {
          throw CustomException(
              'Server side error. Status code: ${response.statusCode}');
        }
      } else {
        throw CustomException(
            'Unknown error. Status code: ${response.statusCode}');
      }
    }
  }
}
