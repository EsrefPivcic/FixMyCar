import 'package:json_annotation/json_annotation.dart';

part 'chat_message.g.dart';

@JsonSerializable()
class ChatMessage {
  int id;
  String senderUserId;
  String recipientUserId;
  String message;
  String sentAt;

  ChatMessage(
    this.id,
    this.senderUserId,
    this.recipientUserId,
    this.message,
    this.sentAt,
  );

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
}
