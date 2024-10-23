import 'dart:convert';

import 'package:fixmycar_client/src/models/user/user_minimal.dart';
import 'package:fixmycar_client/src/providers/chat_history_provider.dart';
import 'package:fixmycar_client/src/providers/user_provider.dart';
import 'package:fixmycar_client/src/screens/chat_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        child: Center(
      child: Card(
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                  ),
                  const SizedBox(height: 5),
                  TextButton(
                    onPressed: () async {
                      if (_usernameController.text.isNotEmpty) {
                        var userProvider =
                            Provider.of<UserProvider>(context, listen: false);

                        try {
                          UserMinimal userExists = await userProvider.exists(
                              username: _usernameController.text);
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                      recipientUserId: userExists.username,
                                      recipientImage: userExists.image!,
                                    )),
                          ).then((_) {
                            _usernameController.text = "";
                          });
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("This user doesn't exist!"),
                            ),
                          );
                          Navigator.of(context).pop();
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter a username!"),
                          ),
                        );
                      }
                    },
                    child: const Text('New Chat'),
                  ),
                  const SizedBox(height: 10),
                  const Text('Previous chats:'),
                  if (chats.isNotEmpty) ...[
                    SizedBox(
                      height: 200,
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
                                    builder: (context) => ChatScreen(
                                      recipientUserId: user.username,
                                      recipientImage: user.image!,
                                    ),
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
                    )
                  ] else ...[
                    const SizedBox(height: 5),
                    const Text('No previous chats found.'),
                  ],
                  TextButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                  recipientUserId: "admin",
                                  recipientImage: "",
                                )),
                      ).then((_) {
                        _usernameController.text = "";
                      });
                    },
                    child: const Text('Contact the admin'),
                  ),
                ],
              ))),
    ));
  }
}
