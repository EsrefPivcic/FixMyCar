import 'package:fixmycar_admin/app.dart';
import 'package:fixmycar_admin/src/providers/admin_provider.dart';
import 'package:fixmycar_admin/src/providers/auth_provider.dart';
import 'package:fixmycar_admin/src/providers/car_parts_shop_provider.dart';
import 'package:fixmycar_admin/src/providers/car_repair_shop_provider.dart';
import 'package:fixmycar_admin/src/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CarPartsShopProvider()),
        ChangeNotifierProvider(create: (_) => CarRepairShopProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider())
      ],
      child: const MyApp(),
    ),
  );
}
