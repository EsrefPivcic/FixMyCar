class Notification {
  final String type;
  final String message;

  Notification({required this.type, required this.message});

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      type: json['type'] as String,
      message: json['message'] as String,
    );
  }
}
