import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fixmycar_car_parts_shop/src/models/search_result.dart';

abstract class BaseProvider<T> with ChangeNotifier {
  static const String baseUrl = 'https://localhost:7055';
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final String endpoint;

  BaseProvider(this.endpoint);

  Future<Map<String, String>> _createHeaders() async {
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
    Map<String, dynamic>? filter,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      String queryString =
          filter != null ? Uri(queryParameters: filter).query : '';
      String url =
          '$baseUrl/$endpoint${queryString.isNotEmpty ? '?$queryString' : ''}';

      final response = await http.get(
        Uri.parse(url),
        headers: await _createHeaders(),
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

  Future<void> insert(T item) async {
    final response = await http.post(
      Uri.parse('$baseUrl/insert'),
      headers: await _createHeaders(),
      body: jsonEncode(item),
    );
    //TODO: Handle response
  }

  Future<void> update(String id, T item) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update/$id'),
      headers: await _createHeaders(),
      body: jsonEncode(item),
    );
    //TODO: Handle response
  }

  Future<void> delete(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete/$id'),
      headers: await _createHeaders(),
    );
    //TODO: Handle response
  }
}
