import 'package:fixmycar_admin/app.dart';
import 'package:fixmycar_admin/src/providers/admin_provider.dart';
import 'package:fixmycar_admin/src/providers/auth_provider.dart';
import 'package:fixmycar_admin/src/providers/chat_history_provider.dart';
import 'package:fixmycar_admin/src/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
        ChangeNotifierProvider(create: (_) => ChatHistoryProvider())
      ],
      child: const MyApp(),
    ),
  );
}
