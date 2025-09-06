class ChatMessage {
  final int id;
  final int senderId;
  final int receiverId;
  final String message;
  final String type;
  final DateTime timestamp; // ✅

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.type,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> j) => ChatMessage(
    id: j['id'],
    senderId: j['senderId'],
    receiverId: j['receiverId'],
    message: j['message'] ?? '',
    type: j['type'] ?? 'text',
    timestamp: DateTime.parse(j['timestamp']), // ISO → DateTime
  );
}
