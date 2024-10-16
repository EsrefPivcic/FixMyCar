import 'package:fixmycar_client/src/models/notification/notification.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'notification_service.dart';

class SignalRNotificationsService {
  late HubConnection connection;
  final NotificationService notificationService = NotificationService();

  SignalRNotificationsService() {
    connection = HubConnectionBuilder()
        .withUrl('http://10.0.2.2:5148/notificationHub')
        .build();
  }

  Future<void> startConnection() async {
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
