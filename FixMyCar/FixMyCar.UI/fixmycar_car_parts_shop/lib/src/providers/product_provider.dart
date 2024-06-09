import 'package:flutter/material.dart';
import 'base_provider.dart';

class ProductProvider extends BaseProvider {
  List<dynamic> products = [];

  Future<void> getProducts() async {
    await get('Product', (data) {
      products = data['result'];
    });
  }
}
