import 'dart:convert';
import 'package:fixmycar_car_repair_shop/src/models/chat_message/chat_message.dart';
import 'package:fixmycar_car_repair_shop/src/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class ChatHistoryProvider extends BaseProvider<ChatMessage, ChatMessage> {
  ChatHistoryProvider() : super('ChatHistory');

  Future<List<ChatMessage>> getChatHistory(
      {required String recipientUserId}) async {
    notifyListeners();

    try {
      String url = '${BaseProvider.baseUrl}/GetChatHistory/$recipientUserId';
      final response = await http.get(
        Uri.parse(url),
        headers: await createHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseBody = jsonDecode(response.body);

        List<ChatMessage> history = responseBody
            .map((item) => ChatMessage.fromJson(item))
            .toList()
            .cast<ChatMessage>();

        return history;
      } else {
        _handleErrors(response);
        throw Exception('Error occurred while fetching chat history.');
      }
    } catch (e) {
      print('Error fetching chat history: $e');
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  void _handleErrors(http.Response response) {
    final responseBody = jsonDecode(response.body);
    final errors = responseBody['errors'] as Map<String, dynamic>?;
    if (errors != null) {
      final userErrors = errors['UserError'] as List<dynamic>?;
      if (userErrors != null) {
        for (var error in userErrors) {
          throw Exception(
              'User error: $error. Status code: ${response.statusCode}');
        }
      } else {
        throw Exception(
            'Server side error. Status code: ${response.statusCode}');
      }
    } else {
      throw Exception('Unknown error. Status code: ${response.statusCode}');
    }
  }
}
