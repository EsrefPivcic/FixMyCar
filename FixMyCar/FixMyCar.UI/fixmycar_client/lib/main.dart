import 'package:fixmycar_client/app.dart';
import 'package:fixmycar_client/src/providers/client_provider.dart';
import 'package:fixmycar_client/src/providers/auth_provider.dart';
import 'package:fixmycar_client/src/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ClientProvider())
      ],
      child: const MyApp(),
    ),
  );
}
