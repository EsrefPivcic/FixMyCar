import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fixmycar_car_parts_shop/src/providers/base_provider.dart';

class AuthProvider extends BaseProvider<void> {
  AuthProvider() : super();

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  set isLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('${BaseProvider.baseUrl}/login'),
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
      isLoggedIn = true;
      print("Login successful!");
    } else {
      final responseBody = json.decode(response.body);
      throw Exception(responseBody['message']);
    }
  }
}
