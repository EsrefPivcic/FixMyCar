import 'package:fixmycar_admin/src/models/search_result.dart';
import 'package:fixmycar_admin/src/models/user/user.dart';
import 'package:fixmycar_admin/src/models/user/user_minimal.dart';
import 'package:fixmycar_admin/src/models/user/user_search_object.dart';
import 'package:fixmycar_admin/src/models/user/user_update.dart';
import 'package:fixmycar_admin/src/models/user/user_update_image.dart';
import 'package:fixmycar_admin/src/providers/base_provider.dart';
import 'package:fixmycar_admin/src/utilities/custom_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProvider extends BaseProvider<User, User> {
  UserProvider() : super('User');

  List<User> users = [];
  int countOfItems = 0;

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

  Future<void> getUsers(
      {required int pageNumber,
      required int pageSize,
      UserSearchObject? search}) async {
    isLoading = true;
    notifyListeners();

    Map<String, dynamic> queryParams = {};

    queryParams['PageNumber'] = pageNumber.toString();
    queryParams['PageSize'] = pageSize.toString();

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

  Future<void> updateByToken({required UserUpdate user}) async {
    toJson(UserUpdate user) => user.toJson();
    try {
      final response = await http.put(
        Uri.parse('${BaseProvider.baseUrl}/$endpoint/UpdateByToken'),
        headers: await createHeaders(),
        body: jsonEncode(toJson(user)),
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
