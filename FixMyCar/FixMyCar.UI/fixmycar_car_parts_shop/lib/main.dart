import 'package:fixmycar_car_parts_shop/src/providers/car_models_by_manufacturer_provider.dart';
import 'package:fixmycar_car_parts_shop/src/providers/car_parts_shop_provider.dart';
import 'package:fixmycar_car_parts_shop/src/providers/order_detail_provider.dart';
import 'package:fixmycar_car_parts_shop/src/providers/order_provider.dart';
import 'package:fixmycar_car_parts_shop/src/providers/store_item_category_provider.dart';
import 'package:fixmycar_car_parts_shop/src/providers/store_item_provider.dart';
import 'package:fixmycar_car_parts_shop/src/providers/car_parts_shop_client_discount_provider.dart';
import 'package:fixmycar_car_parts_shop/src/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fixmycar_car_parts_shop/src/providers/auth_provider.dart';
import 'package:fixmycar_car_parts_shop/app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => StoreItemProvider()),
        ChangeNotifierProvider(create: (_) => StoreItemCategoryProvider()),
        ChangeNotifierProvider(
            create: (_) => CarModelsByManufacturerProvider()),
        ChangeNotifierProvider(
            create: (_) => CarPartsShopClientDiscountProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => OrderDetailProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CarPartsShopProvider())
      ],
      child: const MyApp(),
    ),
  );
}
