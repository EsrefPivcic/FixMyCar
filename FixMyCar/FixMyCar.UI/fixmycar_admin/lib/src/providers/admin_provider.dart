import 'package:fixmycar_admin/src/models/search_result.dart';
import 'package:fixmycar_admin/src/models/user/user.dart';
import 'package:fixmycar_admin/src/providers/base_provider.dart';

class AdminProvider extends BaseProvider<User, User> {
  AdminProvider() : super('Admin');

  User? user;
  bool isLoading = false;

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
