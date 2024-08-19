import 'package:fixmycar_car_repair_shop/src/providers/car_repair_shop_discount_provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/car_repair_shop_service_provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/service_type_provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fixmycar_car_repair_shop/src/providers/auth_provider.dart';
import 'package:fixmycar_car_repair_shop/app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CarRepairShopServiceProvider()),
        ChangeNotifierProvider(create: (_) => ServiceTypeProvider()),
        ChangeNotifierProvider(create: (_) => CarRepairShopDiscountProvider())
      ],
      child: const MyApp(),
    ),
  );
}
