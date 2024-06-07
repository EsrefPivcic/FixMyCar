import 'package:flutter/material.dart';
import 'master_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      child: Center(
        child: Text(
          'Welcome to Home Screen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
