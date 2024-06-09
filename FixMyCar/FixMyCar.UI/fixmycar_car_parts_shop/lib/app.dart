import 'package:flutter/material.dart';
import 'package:fixmycar_car_parts_shop/src/screens/login_screen.dart';
import 'package:fixmycar_car_parts_shop/src/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:fixmycar_car_parts_shop/src/providers/auth_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return MaterialApp(
            title: 'FixMyCar',
            theme: ThemeData.dark().copyWith(),
            home: authProvider.isLoggedIn
                ? const HomeScreen()
                : const LoginScreen(),
          );
        },
      ),
    );
  }
}
