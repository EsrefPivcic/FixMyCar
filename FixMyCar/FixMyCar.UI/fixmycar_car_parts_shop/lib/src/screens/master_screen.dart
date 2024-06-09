import 'package:flutter/material.dart';
import 'items_screen.dart';

class MasterScreen extends StatelessWidget {
  final Widget child;
  final bool showNavigation;

  const MasterScreen(
      {super.key, required this.child, this.showNavigation = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
        flexibleSpace: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('lib/src/assets/images/car-service-icon.png'),
            ),
            if (showNavigation)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildNavButton(context, 'Home'),
                    _buildNavButton(context, 'Orders'),
                    _buildNavButton(context, 'Items'),
                    _buildNavButton(context, 'Discounts'),
                  ],
                ),
              ),
            const SizedBox(width: 56),
          ],
        ),
      ),
      body: child,
    );
  }

  Widget _buildNavButton(BuildContext context, String label) {
    return TextButton(
      onPressed: () {
        if (label == 'Items') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ItemsScreen()),
          );
        } else {
          print('$label button pressed');
        }
      },
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}
