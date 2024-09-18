import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fixmycar_car_parts_shop/src/providers/base_provider.dart';

class AuthProvider extends BaseProvider<AuthProvider, AuthProvider> {
  AuthProvider() : super('Auth');

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  set isLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${BaseProvider.baseUrl}/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
          'role': 'carpartsshop'
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final token = responseBody['token'];
        await storage.write(key: 'jwt_token', value: token);
        isLoggedIn = true;
        print("Login successful!");
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

  Future<void> logout() async {
    final response = await http.post(
      Uri.parse('${BaseProvider.baseUrl}/logout'),
      headers: await createHeaders(),
    );

    if (response.statusCode == 200) {
      await storage.write(key: 'jwt_token', value: '');
      isLoggedIn = false;
      print("Logout successful!");
    } else {
      final responseBody = json.decode(response.body);
      throw Exception(responseBody['message']);
    }
  }
}
