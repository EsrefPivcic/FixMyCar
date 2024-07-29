import 'package:flutter/material.dart';
import 'master_screen.dart';

class DiscountsScreen extends StatelessWidget {
  const DiscountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      child: Center(
        child: Text(
          'Welcome to Discounts Screen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
