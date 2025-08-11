// 📁 File: models/chat_message.dart
import 'package:intl/intl.dart';

class ChatMessage {
  final int senderId;
  final int receiverId;
  final String message;
  final String? media;
  final String type;
  final String timestamp;

  ChatMessage({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.type,
    required this.timestamp,
    this.media,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      message: json['message'] ?? '',
      media: json['media'],
      type: json['type'] ?? 'text',
      timestamp: json['timestamp'] ?? DateFormat('hh:mm a').format(DateTime.now()),
    );
  }
}
