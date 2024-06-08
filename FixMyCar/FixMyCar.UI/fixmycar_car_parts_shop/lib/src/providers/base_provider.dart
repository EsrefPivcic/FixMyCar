import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class BaseProvider<T> with ChangeNotifier {
  static const String baseUrl = 'https://localhost:7055';
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> get() async {
    final response = await http.get(Uri.parse('$baseUrl/get'));
    //TODO: Handle response
  }

  Future<void> insert(T item) async {
    final response = await http.post(
      Uri.parse('$baseUrl/insert'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(item),
    );
    //TODO: Handle response
  }

  Future<void> update(String id, T item) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(item),
    );
    //TODO: Handle response
  }

  Future<void> delete(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete/$id'),
    );
    //TODO: Handle response
  }
}
