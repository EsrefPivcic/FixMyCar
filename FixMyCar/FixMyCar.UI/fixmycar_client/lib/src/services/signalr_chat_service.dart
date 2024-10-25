import 'package:signalr_netcore/signalr_client.dart';

class SignalRChatService {
  late HubConnection _connection;
  final String _baseUrl = "http://10.0.2.2:5148/chatHub";

  Function(String senderUserId, String message)? onMessageReceived;

  Future<void> initConnection(String token) async {
    _connection = HubConnectionBuilder()
        .withUrl(
          _baseUrl,
          options: HttpConnectionOptions(
            accessTokenFactory: () async => token,
          ),
        )
        .build();

    await _connection.start();
    print("Connection established");

    _connection.on("ReceiveMessage", _onReceiveMessage);
  }

  void _onReceiveMessage(List<Object?>? arguments) {
    if (arguments != null && arguments.length >= 2) {
      String senderUserId = arguments[0] as String;
      String message = arguments[1] as String;

      if (onMessageReceived != null) {
        onMessageReceived!(senderUserId, message);
      }
    }
  }

  Future<void> sendMessage(String recipientUserId, String message) async {
    await _connection
        .invoke("SendMessageToUser", args: <Object>[recipientUserId, message]);
  }

  Future<void> stopConnection() async {
    await _connection.stop();
  }
}
