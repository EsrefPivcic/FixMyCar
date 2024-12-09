import 'package:fixmycar_client/constants.dart';
import 'package:fixmycar_client/src/models/notification/notification.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'notification_service.dart';

class SignalRNotificationsService {
  late HubConnection connection;
  final String _baseUrl =
      "http://${ApiHost.address}:${ApiHost.port}/notificationHub";
  final NotificationService notificationService = NotificationService();

  Future<void> startConnection(String token) async {
    connection = HubConnectionBuilder()
        .withUrl(
          _baseUrl,
          options: HttpConnectionOptions(
            accessTokenFactory: () async => token,
          ),
        )
        .build();

    connection.onclose(({Exception? error}) {
      print("Connection closed: ${error?.toString()}");
    });

    connection.on('newNotification', (data) {
      if (data != null && data.isNotEmpty) {
        final notificationMap = data[0] as Map<String, dynamic>;
        final notificationData = Notification.fromJson(notificationMap);

        if (notificationData.type == 'newservice') {
          notificationService.newServiceNotification(
              'New Service', notificationData.message);
        } else if (notificationData.type == 'newstoreitem') {
          notificationService.newStoreItemNotification(
              'New Store Item', notificationData.message);
        }
      }
    });

    await connection
        .start()!
        .catchError((error) => print("Error starting connection: $error"));

    print("Connection established");
  }

  void stopConnection() {
    connection.stop();
  }
}
