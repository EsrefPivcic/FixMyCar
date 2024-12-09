import 'dart:convert';

import 'package:fixmycar_car_parts_shop/src/models/user/user_minimal.dart';
import 'package:fixmycar_car_parts_shop/src/providers/chat_history_provider.dart';
import 'package:fixmycar_car_parts_shop/src/providers/user_provider.dart';
import 'package:fixmycar_car_parts_shop/src/screens/chat_screen.dart';
import 'package:fixmycar_car_parts_shop/src/utilities/custom_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:fixmycar_car_parts_shop/src/screens/discounts_screen.dart';
import 'package:fixmycar_car_parts_shop/src/screens/orders_screen.dart';
import 'package:fixmycar_car_parts_shop/src/screens/store_items_screen.dart';
import 'package:fixmycar_car_parts_shop/src/screens/home_screen.dart';
import 'package:fixmycar_car_parts_shop/src/providers/auth_provider.dart';
import 'package:fixmycar_car_parts_shop/src/screens/login_screen.dart';

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
        backgroundColor: Theme.of(context).hoverColor,
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
                    _buildNavButton(context, 'Orders'),
                    _buildNavButton(context, 'Items'),
                    _buildNavButton(context, 'Discounts'),
                  ],
                ),
              ),
            if (isLoggedIn) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(Icons.chat, color: Colors.white),
                  onPressed: () {
                    _startChatDialog(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: () {
                    _showLogoutDialog(context, authProvider);
                  },
                ),
              ),
            ]
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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const StoreItemsScreen()),
          );
        } else if (label == 'Home') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else if (label == 'Discounts') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DiscountsScreen()),
          );
        } else if (label == 'Orders') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OrdersScreen()),
          );
        } else {
          print('$label button pressed');
        }
      },
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }

  final _usernameController = TextEditingController();

  void _startChatDialog(BuildContext context) async {
    List<UserMinimal> chats = [];

    var chatHistoryProvider =
        Provider.of<ChatHistoryProvider>(context, listen: false);

    chats = await chatHistoryProvider.getChats();

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chat'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Enter recipient username to start a new chat.'),
                TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter recipient username";
                      }
                      return null;
                    }),
                const SizedBox(height: 5),
                TextButton(
                  onPressed: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      var userProvider =
                          Provider.of<UserProvider>(context, listen: false);
                      try {
                        UserMinimal userExists = await userProvider.exists(
                            username: _usernameController.text);
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChatScreen(recipient: userExists)),
                        ).then((_) {
                          _usernameController.text = "";
                        });
                      } on CustomException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                          ),
                        );
                        _usernameController.text = "";
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  child: const Text('New Chat'),
                ),
                const SizedBox(height: 10),
                const Text('Previous chats:'),
                if (chats.isNotEmpty) ...[
                  SizedBox(
                      height: 200,
                      child: SingleChildScrollView(
                        child: Column(
                          children: List.generate(chats.length, (index) {
                            final user = chats[index];
                            return Padding(
                              padding: const EdgeInsets.all(2.5),
                              child: ListTile(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChatScreen(recipient: user),
                                    ),
                                  ).then((_) {
                                    _usernameController.text = "";
                                  });
                                },
                                leading:
                                    user.image != null && user.image!.isNotEmpty
                                        ? CircleAvatar(
                                            maxRadius: 25,
                                            backgroundImage: MemoryImage(
                                                base64Decode(user.image!)),
                                          )
                                        : const CircleAvatar(
                                            maxRadius: 25,
                                            child: Icon(Icons.person),
                                          ),
                                title: Text(
                                  '${user.name} ${user.surname} (${user.username})',
                                ),
                              ),
                            );
                          }),
                        ),
                      ))
                ] else ...[
                  const Text('No previous chats found.'),
                ]
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                var userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                try {
                  UserMinimal userExists =
                      await userProvider.exists(username: "admin");
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ChatScreen(recipient: userExists)),
                  );
                } on CustomException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Contact the admin'),
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
