import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fixmycar_car_parts_shop/src/models/search_result.dart';

abstract class BaseProvider<T, TInsertUpdate> with ChangeNotifier {
  static const String baseUrl = 'https://localhost:7055';
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final String endpoint;

  BaseProvider(this.endpoint);

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

  Future<SearchResult<T>> get({
    String customEndpoint = '',
    Map<String, dynamic>? filter,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      String queryString =
          filter != null ? Uri(queryParameters: filter).query : '';
      String url =
          '$baseUrl/$endpoint${customEndpoint.isNotEmpty ? '/$customEndpoint' : ''}${queryString.isNotEmpty ? '?$queryString' : ''}';
      final response = await http.get(
        Uri.parse(url),
        headers: await createHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        List<T> results =
            (data['result'] as List).map((item) => fromJson(item)).toList();

        return SearchResult<T>(
          count: data['count'],
          result: results,
        );
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      rethrow;
    }
  }

  Future<void> insert(TInsertUpdate item,
      {String customEndpoint = '',
        required Map<String, dynamic> Function(TInsertUpdate) toJson}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint${customEndpoint.isNotEmpty ? '/$customEndpoint' : ''}'),
        headers: await createHeaders(),
        body: jsonEncode(item),
      );

      if (response.statusCode == 200) {
        print('Insert successful.');
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

  Future<void> update(
      {required int id,
      required TInsertUpdate item,
      required Map<String, dynamic> Function(TInsertUpdate) toJson,
      String customEndpoint = ''}) async {
    try {
      final response = await http.put(
        Uri.parse(
            '$baseUrl/$endpoint${customEndpoint.isNotEmpty ? '/$customEndpoint' : ''}/$id'),
        headers: await createHeaders(),
        body: jsonEncode(toJson(item)),
      );
      if (response.statusCode == 200) {
        print('Update successful.');
        notifyListeners();
      } else {
        throw Exception(
            'Failed to update data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating data: $e');
      rethrow;
    }
  }

  Future<void> delete(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$endpoint/$id'),
        headers: await createHeaders(),
      );
      if (response.statusCode == 200) {
        print('Delete successful.');
        notifyListeners();
      } else {
        throw Exception(
            'Failed to delete the item. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting the item: $e');
      rethrow;
    }
  }
}
