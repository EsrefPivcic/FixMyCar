import 'package:flutter/material.dart';
import 'master_screen.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      child: Center(
        child: Text(
          'Welcome to Services Screen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}