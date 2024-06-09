import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class BaseProvider<T> with ChangeNotifier {
  static const String baseUrl = 'https://localhost:7055';
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<Map<String, String>> _createHeaders() async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    // Add JWT token to headers if available
    final String? token = await storage.read(key: 'jwt_token');
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<void> get(String endpoint, Function(dynamic) processData) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: await _createHeaders(),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        processData(data);
        notifyListeners();
      } else {
        // Handle error response
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
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
