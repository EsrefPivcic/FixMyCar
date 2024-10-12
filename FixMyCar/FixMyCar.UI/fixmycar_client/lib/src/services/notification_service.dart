import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> checkAndRequestPermissions() async {
    var status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }

  Future<void> newStoreItemNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'store_item_notification_channel_id',
      'New Store Items Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    _showNotification(title, body, androidPlatformChannelSpecifics);
  }

  Future<void> newServiceNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'car_repair_shop_service_notification_channel_id',
      'New Car Repair Shop Services Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    _showNotification(title, body, androidPlatformChannelSpecifics);
  }

  Future<void> _showNotification(String title, String body,
      AndroidNotificationDetails androidPlatformChannelSpecifics) async {
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}
