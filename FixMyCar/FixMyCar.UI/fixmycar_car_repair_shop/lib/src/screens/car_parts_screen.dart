import 'package:flutter/material.dart';
import 'master_screen.dart';

class CarPartsScreen extends StatelessWidget {
  const CarPartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      child: Center(
        child: Text(
          'Welcome to Car Parts Screen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}