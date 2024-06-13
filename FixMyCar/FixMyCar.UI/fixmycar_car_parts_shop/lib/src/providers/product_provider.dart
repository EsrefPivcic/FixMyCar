import 'base_provider.dart';

class ProductProvider extends BaseProvider {
  List<dynamic> products = [];
  bool isLoading = false;

  Future<void> getProducts({String? nameFilter, bool? withDiscount, String? state}) async {
    isLoading = true;
    notifyListeners();

    Map<String, String> queryParams = {};

    if (nameFilter != null && nameFilter.isNotEmpty) {
      queryParams['Contains'] = nameFilter;
    }
    if (withDiscount != null) {
      queryParams['WithDiscount'] = withDiscount.toString();
    }
    if (state != null && state.isNotEmpty) {
      queryParams['State'] = state;
    }

    String queryString = Uri(queryParameters: queryParams).query;
    String endpoint = 'Product';
    if (queryString.isNotEmpty) {
      endpoint += '?$queryString';
    }

    await get(endpoint, (data) {
      products = data['result'];
      isLoading = false;
      notifyListeners();
    }, onError: () {
      products = [];
      isLoading = false;
      notifyListeners();
    });
  }
}
