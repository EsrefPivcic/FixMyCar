// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
      (json['id'] as num).toInt(),
      json['senderUserId'] as String,
      json['recipientUserId'] as String,
      json['message'] as String,
      json['sentAt'] as String,
    );

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderUserId': instance.senderUserId,
      'recipientUserId': instance.recipientUserId,
      'message': instance.message,
      'sentAt': instance.sentAt,
    };
