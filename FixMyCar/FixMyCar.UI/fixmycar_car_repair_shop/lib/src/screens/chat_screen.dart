import 'package:fixmycar_car_repair_shop/src/models/chat_message/chat_message.dart';
import 'package:fixmycar_car_repair_shop/src/providers/chat_history_provider.dart';
import 'package:fixmycar_car_repair_shop/src/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String recipientUserId;

  ChatScreen({required this.recipientUserId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  void _initializeChat() async {
    final FlutterSecureStorage storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt_token');

    var chatHistoryProvider =
        Provider.of<ChatHistoryProvider>(context, listen: false);

    List<ChatMessage> history = await chatHistoryProvider.getChatHistory(
        recipientUserId: widget.recipientUserId);

    if (history.isNotEmpty) {
      setState(() {
        _messages.addAll(history
            .map((message) => {
                  "sender": message.senderUserId == widget.recipientUserId
                      ? message.senderUserId
                      : "Me",
                  "message": message.message
                })
            .toList());
      });
    }

    _chatService.onMessageReceived = (String senderUserId, String message) {
      if (senderUserId == widget.recipientUserId) {
        setState(() {
          _messages.add({"sender": senderUserId, "message": message});
        });
      }
    };

    await _chatService.initConnection(token!);
  }

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      String message = _controller.text.trim();
      await _chatService.sendMessage(widget.recipientUserId, message);
      setState(() {
        _messages.add({"sender": "Me", "message": message});
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with ${widget.recipientUserId}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Text(message["sender"] ?? ""),
                  subtitle: Text(message["message"] ?? ""),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration:
                        const InputDecoration(hintText: "Enter message"),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _chatService.stopConnection();
    super.dispose();
  }
}
