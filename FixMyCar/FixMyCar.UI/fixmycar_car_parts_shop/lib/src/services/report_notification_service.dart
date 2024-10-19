import 'package:signalr_netcore/signalr_client.dart';

class ReportNotificationService {
  late HubConnection _connection;
  final String _baseUrl = "https://localhost:7055/reportNotificationHub";

  Function(String notificationType, String message)? onNotificationReceived;

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

    _connection.on("ReportNotification", _onReportNotification);
  }

  void _onReportNotification(List<Object?>? arguments) {
    if (arguments != null) {
      String notificationType = arguments[0] as String;
      String message = arguments[1] as String;
      if (onNotificationReceived != null) {
        onNotificationReceived!(notificationType, message);
      }
    }
  }

  Future<void> stopConnection() async {
    if (_connection.state == HubConnectionState.Connected) {
      await _connection.stop();
    }
  }
}
