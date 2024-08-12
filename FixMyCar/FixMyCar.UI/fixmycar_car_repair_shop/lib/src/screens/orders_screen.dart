import 'package:flutter/material.dart';
import 'master_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      child: Center(
        child: Text(
          'Welcome to Orders Screen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}