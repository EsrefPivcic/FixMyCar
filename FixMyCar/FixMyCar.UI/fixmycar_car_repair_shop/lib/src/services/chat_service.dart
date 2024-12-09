import 'package:fixmycar_car_repair_shop/constants.dart';
import 'package:signalr_netcore/signalr_client.dart';

class ChatService {
  late HubConnection _connection;
  final String _baseUrl = 'http://${ApiHost.address}:${ApiHost.port}/chatHub';

  Function(int senderUserId, String message)? onMessageReceived;

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
      int senderUserId = arguments[0] as int;
      String message = arguments[1] as String;

      if (onMessageReceived != null) {
        onMessageReceived!(senderUserId, message);
      }
    }
  }

  Future<void> sendMessage(int recipientUserId, String message) async {
    await _connection
        .invoke("SendMessageToUser", args: <Object>[recipientUserId, message]);
  }

  Future<void> stopConnection() async {
    await _connection.stop();
  }
}
