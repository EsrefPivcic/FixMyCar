import 'dart:io';

import 'package:fixmycar_admin/app.dart';
import 'package:fixmycar_admin/src/providers/admin_provider.dart';
import 'package:fixmycar_admin/src/providers/auth_provider.dart';
import 'package:fixmycar_admin/src/providers/chat_history_provider.dart';
import 'package:fixmycar_admin/src/providers/city_provider.dart';
import 'package:fixmycar_admin/src/providers/recommender_provider.dart';
import 'package:fixmycar_admin/src/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  if (Platform.isWindows) {
    WindowManager.instance.setMinimumSize(const Size(1500, 844));
    WindowManager.instance.setMaximumSize(const Size(3840, 2160));
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
        ChangeNotifierProvider(create: (_) => ChatHistoryProvider()),
        ChangeNotifierProvider(create: (_) => RecommenderProvider()),
        ChangeNotifierProvider(create: (_) => CityProvider())
      ],
      child: const MyApp(),
    ),
  );
}
