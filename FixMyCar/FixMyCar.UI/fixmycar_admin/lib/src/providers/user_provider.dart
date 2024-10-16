import 'package:fixmycar_admin/src/models/search_result.dart';
import 'package:fixmycar_admin/src/models/user/user.dart';
import 'package:fixmycar_admin/src/models/user/user_search_object.dart';
import 'package:fixmycar_admin/src/models/user/user_update.dart';
import 'package:fixmycar_admin/src/models/user/user_update_image.dart';
import 'package:fixmycar_admin/src/models/user/user_update_password.dart';
import 'package:fixmycar_admin/src/models/user/user_update_username.dart';
import 'package:fixmycar_admin/src/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProvider extends BaseProvider<User, User> {
  UserProvider() : super('User');

  List<User> users = [];
  int countOfItems = 0;

  User? user;
  bool isLoading = false;

  Future<bool> exists({required String username}) async {
    notifyListeners();

    try {
      String url = '${BaseProvider.baseUrl}/$endpoint/Exists/$username';
      final response = await http.get(
        Uri.parse(url),
        headers: await createHeaders(),
      );

      if (response.statusCode == 200) {
        String responseBody = response.body.trim();
        bool exists = responseBody.toLowerCase() == 'true';
        return exists;
      } else {
        _handleErrors(response);
        throw Exception('Error occurred while checking if user exists.');
      }
    } catch (e) {
      print('Error checking if user exists: $e');
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  void _handleErrors(http.Response response) {
    final responseBody = jsonDecode(response.body);
    final errors = responseBody['errors'] as Map<String, dynamic>?;
    if (errors != null) {
      final userErrors = errors['UserError'] as List<dynamic>?;
      if (userErrors != null) {
        for (var error in userErrors) {
          throw Exception(
              'User error: $error. Status code: ${response.statusCode}');
        }
      } else {
        throw Exception(
            'Server side error. Status code: ${response.statusCode}');
      }
    } else {
      throw Exception('Unknown error. Status code: ${response.statusCode}');
    }
  }

  Future<void> getUsers({UserSearchObject? search}) async {
    isLoading = true;
    notifyListeners();

    Map<String, dynamic> queryParams = {};

    if (search != null) {
      if (search.containsUsername != null) {
        if (search.containsUsername!.isNotEmpty) {
          queryParams['ContainsUsername'] = search.containsUsername;
        }
      }
      if (search.role != null) {
        if (search.role!.isNotEmpty) {
          queryParams['Role'] = search.role;
        }
      } else {
        queryParams['Role'] = 'allexceptadmin';
      }
      if (search.active != null) {
        queryParams['Active'] = search.active.toString();
      }
    }

    try {
      SearchResult<User> searchResult = await get(
        filter: queryParams,
        fromJson: (json) => User.fromJson(json),
      );

      users = searchResult.result;
      countOfItems = searchResult.count;
      isLoading = false;
    } catch (e) {
      users = [];
      countOfItems = 0;
      isLoading = false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> changeActiveStatus(int id) async {
    try {
      final response = await http.put(
          Uri.parse(
              '${BaseProvider.baseUrl}/$endpoint/ChangeActiveStatus?id=$id'),
          headers: await createHeaders());
      if (response.statusCode == 200) {
        print('Active status changed successfully.');
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

  Future<void> updateByToken({required UserUpdate user}) async {
    toJson(UserUpdate user) => user.toJson();
    try {
      final response = await http.put(
        Uri.parse('${BaseProvider.baseUrl}/$endpoint/UpdateByToken'),
        headers: await createHeaders(),
        body: jsonEncode(toJson(user)),
      );
      if (response.statusCode == 200) {
        print('Update successful.');
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

  Future<void> updatePassword(
      {required UserUpdatePassword updatePassword}) async {
    toJson(UserUpdatePassword updatePassword) => updatePassword.toJson();
    try {
      final response = await http.put(
        Uri.parse('${BaseProvider.baseUrl}/$endpoint/UpdatePasswordByToken'),
        headers: await createHeaders(),
        body: jsonEncode(toJson(updatePassword)),
      );
      if (response.statusCode == 200) {
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

  Future<void> updateUsername(
      {required UserUpdateUsername updateUsername}) async {
    toJson(UserUpdateUsername updateUsername) => updateUsername.toJson();
    try {
      final response = await http.put(
        Uri.parse('${BaseProvider.baseUrl}/$endpoint/UpdateUsernameByToken'),
        headers: await createHeaders(),
        body: jsonEncode(toJson(updateUsername)),
      );
      if (response.statusCode == 200) {
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

  Future<void> updateImage({required UserUpdateImage updateImage}) async {
    toJson(UserUpdateImage updateImage) => updateImage.toJson();
    try {
      final response = await http.put(
        Uri.parse('${BaseProvider.baseUrl}/$endpoint/UpdateImageByToken'),
        headers: await createHeaders(),
        body: jsonEncode(toJson(updateImage)),
      );
      if (response.statusCode == 200) {
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
}
