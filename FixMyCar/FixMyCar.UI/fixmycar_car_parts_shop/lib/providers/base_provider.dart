import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class BaseProvider<T> with ChangeNotifier {
  static const String _baseUrl = 'https://TODO:localhost:7055';
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> get() async {
    final response = await http.get(Uri.parse('$_baseUrl/get'));
    //TODO: Handle response
  }

  Future<void> insert(T item) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/insert'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(item),
    );
    //TODO: Handle response
  }

  Future<void> update(String id, T item) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/update/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(item),
    );
    //TODO: Handle response
  }

  Future<void> delete(String id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/delete/$id'),
    );
    //TODO: Handle response
  }

  Future<void> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final token = responseBody['token'];
      await storage.write(key: 'jwt_token', value: token);
      print("Login successful.");
      notifyListeners();
    } else {
      final responseBody = json.decode(response.body);
      throw Exception(responseBody['message']);
    }
  }
}
