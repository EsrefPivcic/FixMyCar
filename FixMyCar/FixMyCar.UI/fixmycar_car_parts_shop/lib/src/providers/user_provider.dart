import 'package:fixmycar_car_parts_shop/src/models/user/user.dart';
import 'package:fixmycar_car_parts_shop/src/models/user/user_minimal.dart';
import 'package:fixmycar_car_parts_shop/src/models/user/user_register.dart';
import 'package:fixmycar_car_parts_shop/src/models/user/user_update.dart';
import 'package:fixmycar_car_parts_shop/src/models/user/user_update_image.dart';
import 'package:fixmycar_car_parts_shop/src/models/user/user_update_password.dart';
import 'package:fixmycar_car_parts_shop/src/models/user/user_update_username.dart';
import 'package:fixmycar_car_parts_shop/src/providers/base_provider.dart';
import 'package:fixmycar_car_parts_shop/src/utilities/custom_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProvider extends BaseProvider<User, UserRegister> {
  UserProvider() : super('User');

  User? user;
  bool isLoading = false;

  Future<UserMinimal> exists({required String username}) async {
    notifyListeners();

    try {
      String url = '${BaseProvider.baseUrl}/$endpoint/Exists/$username';
      final response = await http.get(
        Uri.parse(url),
        headers: await createHeaders(),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        UserMinimal user = UserMinimal.fromJson(responseBody);
        return user;
      } else {
        handleHttpError(response);
        throw CustomException('Unhandled HTTP error');
      }
    } on CustomException {
      rethrow;
    } catch (e) {
      throw CustomException(
          "Can't reach the server. Please check your internet connection.");
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateByToken({required UserUpdate user}) async {
    print("im here");
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
        handleHttpError(response);
      }
    } on CustomException {
      rethrow;
    } catch (e) {
      throw CustomException(
          "Can't reach the server. Please check your internet connection.");
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
        handleHttpError(response);
      }
    } on CustomException {
      rethrow;
    } catch (e) {
      throw CustomException(
          "Can't reach the server. Please check your internet connection.");
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
        handleHttpError(response);
      }
    } on CustomException {
      rethrow;
    } catch (e) {
      throw CustomException(
          "Can't reach the server. Please check your internet connection.");
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
        handleHttpError(response);
      }
    } on CustomException {
      rethrow;
    } catch (e) {
      throw CustomException(
          "Can't reach the server. Please check your internet connection.");
    }
  }
}
