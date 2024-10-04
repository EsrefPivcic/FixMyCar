import 'package:dart_amqp/dart_amqp.dart';
import 'notification_service.dart';

class RabbitMQService {
  late Client client;
  final NotificationService notificationService = NotificationService();

  RabbitMQService() {
    ConnectionSettings settings = ConnectionSettings(
      host: '10.0.2.2',
      authProvider: PlainAuthenticator('guest', 'guest'),
    );
    client = Client(settings: settings);
  }

  Future<void> startListening() async {
    await notificationService.init();

    Channel channel = await client.channel();

    await _listenOnQueue(channel, "product_notifications", "New Product");

    await _listenOnQueue(
        channel, "service_notifications", "New Repair Shop Service");
  }

  Future<void> _listenOnQueue(
      Channel channel, String queueName, String title) async {
    Queue queue = await channel.queue(queueName, durable: false);
    Consumer consumer = await queue.consume();

    consumer.listen((AmqpMessage message) {
      String notificationMessage = message.payloadAsString;

      notificationService.showNotification(
        title,
        notificationMessage,
      );

      print("New notification from $queueName: $notificationMessage");
    });
  }

  void closeConnection() {
    client.close();
  }
}
