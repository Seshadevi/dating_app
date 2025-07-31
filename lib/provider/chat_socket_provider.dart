import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:intl/intl.dart';
import 'package:dating/provider/loginProvider.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, List<MessageData>>((ref) {
  final token = ref.read(loginProvider).data?.first.accessToken;
  if (token == null) throw Exception("No token found");
  return ChatNotifier(token);
});

class ChatNotifier extends StateNotifier<List<MessageData>> {
  final String token;
  late IO.Socket socket;
  int? activeChatUserId;

  ChatNotifier(this.token) : super([]) {
    _initSocket();
  }

  void _initSocket() {
    socket = IO.io('ws://97.74.93.26:6100', IO.OptionBuilder()
        .setTransports(['websocket'])
        .setAuth({'token': token})
        .enableForceNew()
        .enableReconnection()
        .build());

    socket.onConnect((_) => print('✅ Connected'));

    socket.on('receiveMessage', (data) {
      print('📥 Message received: $data');
      if (data['senderId'] == activeChatUserId || data['receiverId'] == activeChatUserId) {
        final msg = MessageData(
          senderId: data['senderId'],
          receiverId: data['receiverId'],
          message: data['message'],
          timestamp: DateFormat('hh:mm a').format(DateTime.parse(data['timestamp'])),
        );
        state = [...state, msg];
      }
    });
  }

  void openChat(int withUserId) {
    activeChatUserId = withUserId;
    socket.emit('fetchMessages', { 'withUserId': withUserId });
    socket.on('chatHistory', (data) {
      final history = (data['messages'] as List).map((m) => MessageData(
        senderId: m['senderId'],
        receiverId: m['receiverId'],
        message: m['message'],
        timestamp: DateFormat('hh:mm a').format(DateTime.parse(m['timestamp'])),
      )).toList();
      state = history;
    });
  }

  void sendMessage(int toUserId, String msg) {
    socket.emit('sendMessage', {
      'receiverId': toUserId,
      'message': msg,
    });
  }

  void disposeSocket() {
    socket.disconnect();
  }
}

class MessageData {
  final int senderId;
  final int receiverId;
  final String message;
  final String timestamp;

  MessageData({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });
}