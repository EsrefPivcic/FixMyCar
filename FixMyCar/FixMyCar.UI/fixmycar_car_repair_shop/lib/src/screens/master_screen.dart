import 'package:fixmycar_car_repair_shop/src/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fixmycar_car_repair_shop/src/screens/home_screen.dart';
import 'package:fixmycar_car_repair_shop/src/screens/reservations_screen.dart';
import 'package:fixmycar_car_repair_shop/src/screens/services_screen.dart';
import 'package:fixmycar_car_repair_shop/src/screens/discounts_screen.dart';
import 'package:fixmycar_car_repair_shop/src/screens/car_parts_shops_screen.dart';
import 'package:fixmycar_car_repair_shop/src/providers/auth_provider.dart';
import 'package:fixmycar_car_repair_shop/src/screens/login_screen.dart';

class MasterScreen extends StatelessWidget {
  final Widget child;
  final bool showBackButton;

  MasterScreen({super.key, required this.child, required this.showBackButton});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isLoggedIn = authProvider.isLoggedIn;

    double leftPadding = showBackButton ? 55 : 8;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: showBackButton,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
        flexibleSpace: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: leftPadding, top: 8.0, right: 8.0, bottom: 8.0),
              child: Image.asset('lib/src/assets/images/car-service-icon.png'),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text.rich(TextSpan(
                text: "FixMyCar",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              )),
            ),
            if (isLoggedIn)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildNavButton(context, 'Home'),
                    _buildNavButton(context, 'Reservations'),
                    _buildNavButton(context, 'Services'),
                    _buildNavButton(context, 'Discounts'),
                    _buildNavButton(context, 'Car Parts'),
                    _buildNavButton(context, 'Chat'),
                  ],
                ),
              ),
            if (isLoggedIn)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: () {
                    _showLogoutDialog(context, authProvider);
                  },
                ),
              ),
          ],
        ),
      ),
      body: child,
    );
  }

  Widget _buildNavButton(BuildContext context, String label) {
    return TextButton(
      onPressed: () {
        if (label == 'Home') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else if (label == 'Discounts') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DiscountsScreen()),
          );
        } else if (label == 'Reservations') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReservationsScreen()),
          );
        } else if (label == 'Car Parts') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CarPartsShopsScreen()),
          );
        } else if (label == 'Services') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ServicesScreen()),
          );
        } else if (label == 'Chat') {
          _chatUserDialog(context);
        } else {
          print('$label button pressed');
        }
      },
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }

  final _usernameController = TextEditingController();

  void _chatUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chat'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Enter recipient username to start a chat.'),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
          ]),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                if (_usernameController.text.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatScreen(
                              recipientUserId: _usernameController.text,
                            )),
                  ).then((_) {
                    _usernameController.text = "";
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter a username!"),
                    ),
                  );
                }
              },
              child: const Text('Chat'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await authProvider.logout().then((_) {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );
                }
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
