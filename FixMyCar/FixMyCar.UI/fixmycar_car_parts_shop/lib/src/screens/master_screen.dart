import 'package:flutter/material.dart';

class MasterScreen extends StatelessWidget {
  final Widget child;
  final bool showNavigation;

  const MasterScreen({Key? key, required this.child, this.showNavigation = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            SizedBox(width: 56),
          ],
        ),
      ),
      body: child,
    );
  }

  Widget _buildNavButton(BuildContext context, String label) {
    return TextButton(
      onPressed: () {
        // TODO: Add navigation logic
        print('$label button pressed');
      },
      child: Text(label, style: TextStyle(color: Colors.white)),
    );
  }
}
