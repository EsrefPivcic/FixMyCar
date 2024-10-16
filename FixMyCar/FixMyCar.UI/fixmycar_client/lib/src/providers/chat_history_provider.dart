import 'dart:convert';
import 'package:fixmycar_client/src/models/chat_message/chat_message.dart';
import 'package:fixmycar_client/src/models/search_result.dart';
import 'package:fixmycar_client/src/models/user/user_minimal.dart';
import 'package:fixmycar_client/src/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class ChatHistoryProvider extends BaseProvider<UserMinimal, ChatMessage> {
  ChatHistoryProvider() : super('ChatHistory');

  Future<List<UserMinimal>> getChats() async {
    notifyListeners();

    try {
      SearchResult<UserMinimal> searchResult = await get(
          fromJson: (json) => UserMinimal.fromJson(json),
          customEndpoint: "GetChats");

      List<UserMinimal> chats = searchResult.result;
      notifyListeners();
      return chats;
    } catch (e) {
      notifyListeners();
      throw Exception('Error occurred while fetching chats.');
    }
  }

  Future<List<ChatMessage>> getChatHistory(
      {required String recipientUserId}) async {
    notifyListeners();

    try {
      String url =
          '${BaseProvider.baseUrl}/$endpoint/GetChatHistory/$recipientUserId';
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
