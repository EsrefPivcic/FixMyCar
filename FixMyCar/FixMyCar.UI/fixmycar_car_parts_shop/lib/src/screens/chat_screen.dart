import 'dart:convert';

import 'package:fixmycar_car_parts_shop/src/models/chat_message/chat_message.dart';
import 'package:fixmycar_car_parts_shop/src/providers/chat_history_provider.dart';
import 'package:fixmycar_car_parts_shop/src/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String recipientUserId;
  final String recipientImage;

  ChatScreen({required this.recipientUserId, required this.recipientImage});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();
  final ScrollController _scrollController = ScrollController();

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
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _maybeScrollToBottom();
        });
      }
    };

    await _chatService.initConnection(token!).then((_) {
      setState(() {
        _scrollToBottom();
      });
      _focusNode.requestFocus();
    });
  }

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      String message = _controller.text.trim();
      await _chatService.sendMessage(widget.recipientUserId, message);
      setState(() {
        _messages.add({"sender": "Me", "message": message});
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
      _controller.clear();
    }
  }

  void _maybeScrollToBottom() {
    if (_scrollController.hasClients) {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;

      if (maxScroll - currentScroll < 500) {
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget _buildMessageBubble(String sender, String message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          color: isMe
              ? const Color.fromARGB(101, 45, 30, 99)
              : const Color.fromARGB(19, 255, 255, 255),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              sender,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isMe
                    ? Color.fromARGB(255, 146, 115, 241)
                    : Color.fromARGB(174, 255, 255, 255),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              message,
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              if (widget.recipientImage.isNotEmpty) ...[
                CircleAvatar(
                  backgroundImage:
                      MemoryImage(base64Decode(widget.recipientImage)),
                )
              ] else ...[
                const CircleAvatar(
                  child: Icon(Icons.person),
                )
              ],
              const SizedBox(width: 8),
              Text("Chat with ${widget.recipientUserId}"),
            ],
          ),
        ),
        body: Center(
          child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Card(
                  child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _messages.length,
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          bool isMe = message["sender"] == "Me";
                          return _buildMessageBubble(
                            message["sender"] ?? "",
                            message["message"] ?? "",
                            isMe,
                          );
                        },
                      ),
                    ),
                    const Divider(height: 1.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              focusNode: _focusNode,
                              onSubmitted: (value) {
                                _sendMessage();
                                _focusNode.requestFocus();
                              },
                              maxLines: 1,
                              controller: _controller,
                              decoration: InputDecoration(
                                hintText: "Enter message...",
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 15.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          FloatingActionButton(
                            onPressed: () {
                              _sendMessage();
                              _focusNode.requestFocus();
                            },
                            backgroundColor: Theme.of(context).primaryColor,
                            child: const Icon(Icons.send),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ))),
        ));
  }

  @override
  void dispose() {
    _chatService.stopConnection();
    super.dispose();
  }
}
