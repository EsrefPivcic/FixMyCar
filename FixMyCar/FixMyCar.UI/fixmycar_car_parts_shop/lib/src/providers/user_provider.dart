import 'package:fixmycar_car_parts_shop/src/models/user/user.dart';
import 'package:fixmycar_car_parts_shop/src/models/user/user_register.dart';
import 'package:fixmycar_car_parts_shop/src/providers/base_provider.dart';
import 'package:fixmycar_car_parts_shop/src/models/search_result.dart';

class UserProvider extends BaseProvider<User, UserRegister> {
  UserProvider() : super('User');

  User? user;
  bool isLoading = false;

  Future<void> insertUser(UserRegister user) async {
    await insert(
      user,
      customEndpoint: 'InsertCarPartsShop',
      toJson: (user) => user.toJson(),
    );
  }

  Future<void> getByToken() async {
    isLoading = true;
    notifyListeners();

    try {
      SearchResult<User> searchResult = await get(
        customEndpoint: 'GetByToken',
        fromJson: (json) => User.fromJson(json),
      );

      user = searchResult.result[0];
    } catch (e) {
      user = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
