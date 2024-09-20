import 'package:fixmycar_admin/src/models/search_result.dart';
import 'package:fixmycar_admin/src/models/user/user.dart';
import 'package:fixmycar_admin/src/models/user/user_register.dart';
import 'package:fixmycar_admin/src/providers/base_provider.dart';

class AdminProvider extends BaseProvider<User, UserRegister> {
  AdminProvider() : super('Admin');

  User? user;
  bool isLoading = false;

  Future<void> insertUser(UserRegister user) async {
    await insert(
      user,
      customEndpoint: 'InsertAdmin',
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
