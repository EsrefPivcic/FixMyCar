import 'package:fixmycar_client/src/screens/car_parts_shops_screen.dart';
import 'package:fixmycar_client/src/screens/car_repair_shops_screen.dart';
import 'package:flutter/material.dart';
import 'master_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CarRepairShopsScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                minimumSize: const Size(double.infinity, 150),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'lib/src/assets/images/repair-shop.png',
                    height: 100,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Car Repair Shops',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CarPartsShopsScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                minimumSize: const Size(double.infinity, 150),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'lib/src/assets/images/parts-shop.png',
                    height: 100,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Car Parts Shops',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
