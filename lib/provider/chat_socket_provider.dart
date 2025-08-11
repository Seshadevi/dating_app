// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:intl/intl.dart';
// import 'package:dating/provider/loginProvider.dart';

// final chatProvider = StateNotifierProvider<ChatNotifier, List<MessageData>>((ref) {
//   final token = ref.read(loginProvider).data?.first.accessToken;
//   if (token == null) throw Exception("No token found");
//   return ChatNotifier(token);
// });

// class ChatNotifier extends StateNotifier<List<MessageData>> {
//   final String token;
//   late IO.Socket socket;
//   int? activeChatUserId;

//   ChatNotifier(this.token) : super([]) {
//     _initSocket();
//   }

//   void _initSocket() {
//     socket = IO.io('ws://97.74.93.26:6100', IO.OptionBuilder()
//         .setTransports(['websocket'])
//         .setAuth({'token': token})
//         .enableForceNew()
//         .enableReconnection()
//         .build());

//     socket.onConnect((_) => print('✅ Connected'));

//     socket.on('receiveMessage', (data) {
//       print('📥 Message received: $data');
//       if (data['senderId'] == activeChatUserId || data['receiverId'] == activeChatUserId) {
//         final msg = MessageData(
//           senderId: data['senderId'],
//           receiverId: data['receiverId'],
//           message: data['message'],
//           timestamp: DateFormat('hh:mm a').format(DateTime.parse(data['timestamp'])),
//         );
//         state = [...state, msg];
//       }
//     });
//   }

//   void openChat(int withUserId) {
//     activeChatUserId = withUserId;
//     socket.emit('fetchMessages', { 'withUserId': withUserId });
//     socket.on('chatHistory', (data) {
//       final history = (data['messages'] as List).map((m) => MessageData(
//         senderId: m['senderId'],
//         receiverId: m['receiverId'],
//         message: m['message'],
//         timestamp: DateFormat('hh:mm a').format(DateTime.parse(m['timestamp'])),
//       )).toList();
//       state = history;
//     });
//   }

//   void sendMessage(int toUserId, String msg) {
//     socket.emit('sendMessage', {
//       'receiverId': toUserId,
//       'message': msg,
//     });
//   }

//   void disposeSocket() {
//     socket.disconnect();
//   }
// }

// class MessageData {
//   final int senderId;
//   final int receiverId;
//   final String message;
//   final String timestamp;

//   MessageData({
//     required this.senderId,
//     required this.receiverId,
//     required this.message,
//     required this.timestamp,
//   });
// }


import 'package:dating/model/chat_message.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final chatProvider =
    StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
  final accessToken = ref.read(loginProvider).data?.first.accessToken;
  if (accessToken == null) {
    throw Exception("Access token is null. Cannot initialize chat.");
  }
  return ChatNotifier(accessToken);
});

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  late IO.Socket _socket;
  final String accessToken;
  bool _initialized = false;
  int? _currentChatUserId;

  ChatNotifier(this.accessToken) : super([]) {
    _initSocket();
  }

  void _initSocket() {
    if (_initialized) return;

    _socket = IO.io(
      'ws://97.74.93.26:6100',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': accessToken})
          .enableForceNew()
          .build(),
    );

    _socket.onConnect((_) => print("✅ Socket Connected"));

    // When message is sent (self)
    _socket.on('messageSent', (data) {
      final msg = ChatMessage.fromJson(data);
      if (_currentChatUserId == msg.receiverId || _currentChatUserId == msg.senderId) {
        state = [...state, msg];
      }
    });

    // When message is received (from others)
    _socket.on('receiveMessage', (data) {
      final msg = ChatMessage.fromJson(data);
      if (_currentChatUserId == msg.senderId || _currentChatUserId == msg.receiverId) {
        state = [...state, msg];
      }
    });

    // Single listener for chat history
    _socket.on('chatHistory', (data) {
      final List<ChatMessage> msgs = List<ChatMessage>.from(
        data['messages'].map((m) => ChatMessage.fromJson(m)),
      );
      state = msgs;
    });

    _socket.onDisconnect((_) => print("🔌 Socket Disconnected"));
    _initialized = true;
  }

  void fetchMessages(int withUserId) {
    _currentChatUserId = withUserId;
    _socket.emit('fetchMessages', {'withUserId': withUserId});
  }

  void sendMessage(int receiverId, String message) {
    _socket.emit('sendMessage', {
      'receiverId': receiverId,
      'message': message,
    });
  }

  @override
  void dispose() {
    _socket.dispose();
    super.dispose();
  }
}

// import 'package:dating/model/chat_message.dart';
// import 'package:dating/provider/loginProvider.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:intl/intl.dart';
//  // contains loginProvider

// final chatProvider = StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
//   final accessToken = ref.read(loginProvider).data?.first.accessToken;
//   if (accessToken == null) {
//     throw Exception("Access token is null. Cannot initialize chat.");
//   }
//   return ChatNotifier(accessToken);
// });

// class ChatNotifier extends StateNotifier<List<ChatMessage>> {
//   late IO.Socket _socket;
//   final String accessToken;
//   bool _initialized = false;

//   ChatNotifier(this.accessToken) : super([]) {
//     _initSocket();
//   }

//   void _initSocket() {
//     if (_initialized) return;
//     _socket = IO.io('ws://97.74.93.26:6100', IO.OptionBuilder()
//         .setTransports(['websocket'])
//         .setAuth({'token': accessToken})
//         .build());

//     _socket.onConnect((_) => print("✅ Socket Connected"));

//     _socket.on('receiveMessage', (data) {
//       final msg = ChatMessage.fromJson(data);
//       state = [...state, msg];
//     });

//     _socket.onDisconnect((_) => print("🔌 Socket Disconnected"));

//     _initialized = true;
//   }

//   void sendMessage(int receiverId, String message) {
//     _socket.emit('sendMessage', {
//       'receiverId': receiverId,
//       'message': message,
//     });
//   }

//   void fetchMessages(int withUserId) {
//     _socket.emit('fetchMessages', {'withUserId': withUserId});
//     _socket.on('chatHistory', (data) {
//       final List<ChatMessage> msgs = List<ChatMessage>.from(
//         data['messages'].map((m) => ChatMessage.fromJson(m)),
//       );
//       state = msgs;
//     });
//   }
// }
