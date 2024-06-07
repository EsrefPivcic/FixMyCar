import 'package:fixmycar_car_parts_shop/src/providers/base_provider.dart';

class AuthProvider extends BaseProvider<void> {
  AuthProvider() : super();

  bool get isLoggedIn => BaseProvider.isLoggedIn;
  set isLoggedIn(bool value) {
    BaseProvider.isLoggedIn = value;
    notifyListeners();
  }
}
