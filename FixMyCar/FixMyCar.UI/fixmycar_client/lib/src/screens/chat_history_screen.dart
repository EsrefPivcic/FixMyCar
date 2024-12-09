import 'dart:convert';

import 'package:fixmycar_client/src/models/user/user_minimal.dart';
import 'package:fixmycar_client/src/providers/chat_history_provider.dart';
import 'package:fixmycar_client/src/providers/user_provider.dart';
import 'package:fixmycar_client/src/screens/chat_screen.dart';
import 'package:fixmycar_client/src/utilities/custom_exception.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'master_screen.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      List<UserMinimal> chatsTemp =
          await Provider.of<ChatHistoryProvider>(context, listen: false)
              .getChats();
      if (mounted) {
        setState(() {
          chats = chatsTemp;
        });
      }
    });
  }

  late List<UserMinimal> chats = [];
  final _usernameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        child: Center(
      child: Card(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.90,
                maxWidth: MediaQuery.of(context).size.width * 0.90,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Enter recipient username to start a new chat.'),
                    TextFormField(
                        controller: _usernameController,
                        decoration:
                            const InputDecoration(labelText: 'Username'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter recipient username";
                          }
                          return null;
                        }),
                    const SizedBox(height: 5),
                    TextButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          var userProvider =
                              Provider.of<UserProvider>(context, listen: false);

                          try {
                            UserMinimal userExists = await userProvider.exists(
                                username: _usernameController.text);

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChatScreen(recipient: userExists)),
                            ).then((_) {
                              _usernameController.text = "";
                            });
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('New Chat'),
                    ),
                    const SizedBox(height: 10),
                    const Text('Previous chats:'),
                    if (chats.isNotEmpty) ...[
                      SizedBox(
                        height: 350,
                        child: SingleChildScrollView(
                          child: Column(
                            children: List.generate(chats.length, (index) {
                              final user = chats[index];
                              return Padding(
                                padding: const EdgeInsets.all(2.5),
                                child: ListTile(
                                  onTap: () {
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
                                  leading: user.image != null &&
                                          user.image!.isNotEmpty
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
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 5),
                      const Text('No previous chats found.'),
                    ],
                    TextButton(
                      onPressed: () async {
                        var userProvider =
                            Provider.of<UserProvider>(context, listen: false);
                        try {
                          UserMinimal userExists =
                              await userProvider.exists(username: "admin");
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
                        }
                      },
                      child: const Text('Contact the admin'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
