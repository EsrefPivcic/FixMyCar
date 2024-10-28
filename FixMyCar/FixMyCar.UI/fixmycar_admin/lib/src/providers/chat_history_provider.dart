import 'dart:convert';
import 'package:fixmycar_admin/src/models/chat_message/chat_message.dart';
import 'package:fixmycar_admin/src/models/search_result.dart';
import 'package:fixmycar_admin/src/models/user/user_minimal.dart';
import 'package:fixmycar_admin/src/providers/base_provider.dart';
import 'package:fixmycar_admin/src/utilities/custom_exception.dart';
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
      rethrow;
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
        handleHttpError(response);
        throw CustomException('Unhandled HTTP error');
      }
    } on CustomException {
      rethrow;
    } catch (e) {
      throw CustomException(
          "Can't reach the server. Please check your internet connection.");
    } finally {
      notifyListeners();
    }
  }
}
