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






































// import 'package:dating/model/chat_message.dart';
// import 'package:dating/provider/loginProvider.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// final chatProvider =
//     StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
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
//   int? _currentChatUserId;

//   ChatNotifier(this.accessToken) : super([]) {
//     _initSocket();
//   }

//   void _initSocket() {
//     if (_initialized) return;

//     _socket = IO.io(
//       'ws://97.74.93.26:6100',
//       IO.OptionBuilder()
//           .setTransports(['websocket'])
//           .setAuth({'token': accessToken})
//           .enableForceNew()
//           .build(),
//     );

//     _socket.onConnect((_) => print("✅ Socket Connected"));

//     // When message is sent (self)
//     _socket.on('messageSent', (data) {
//       final msg = ChatMessage.fromJson(data);
//       if (_currentChatUserId == msg.receiverId || _currentChatUserId == msg.senderId) {
//         state = [...state, msg];
//       }
//     });

//     // When message is received (from others)
//     _socket.on('receiveMessage', (data) {
//       final msg = ChatMessage.fromJson(data);
//       if (_currentChatUserId == msg.senderId || _currentChatUserId == msg.receiverId) {
//         state = [...state, msg];
//       }
//     });

//     // Single listener for chat history
//     _socket.on('chatHistory', (data) {
//       final List<ChatMessage> msgs = List<ChatMessage>.from(
//         data['messages'].map((m) => ChatMessage.fromJson(m)),
//       );
//       state = msgs;
//     });

//     _socket.onDisconnect((_) => print("🔌 Socket Disconnected"));
//     _initialized = true;
//   }

//   void fetchMessages(int withUserId) {
//     _currentChatUserId = withUserId;
//     _socket.emit('fetchMessages', {'withUserId': withUserId});
//   }

//   void sendMessage(int receiverId, String message) {
//     _socket.emit('sendMessage', {
//       'receiverId': receiverId,
//       'message': message,
//     });
//   }

//   @override
//   void dispose() {
//     _socket.dispose();
//     super.dispose();
//   }
// }































// import 'dart:async';
// import 'package:dating/model/chat_message.dart';
// import 'package:dating/provider/loginProvider.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// /// UI flags
// final typingProvider = StateProvider<bool>((_) => false);

// /// Presence (only useful if your backend emits `presence` / `presenceBatch`)
// /// If you haven't added presence on the backend yet, this provider will just stay null.
// final presenceProvider =
//     StateProvider<({bool online, DateTime? lastSeen})?>((_) => null);

// final chatProvider =
//     StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
//   final accessToken = ref.read(loginProvider).data?.first.accessToken;
//   if (accessToken == null) {
//     throw Exception("Access token is null. Cannot initialize chat.");
//   }
//   return ChatNotifier(accessToken, ref); // pass ref so we can update typing/presence providers
// });

// class ChatNotifier extends StateNotifier<List<ChatMessage>> {
//   final Ref _ref;
//   final String accessToken;
//   late IO.Socket _socket;

//   bool _initialized = false;
//   int? _currentChatUserId; // who we're chatting with
//   int? _activePeer;        // same as _currentChatUserId, used in event handlers

//   Timer? _typingHideTimer;

//   ChatNotifier(this.accessToken, this._ref) : super([]) {
//     _initSocket();
//   }

//   void _initSocket() {
//     if (_initialized) return;

//     _socket = IO.io(
//       'ws://97.74.93.26:6100',
//       IO.OptionBuilder()
//           .setTransports(['websocket'])
//           .setAuth({'token': accessToken})
//           .enableForceNew()
//           .build(),
//     );

//     _socket.onConnect((_) {
//       // print("✅ Chat socket connected");
//     });

//     // Self confirmation
//     _socket.on('messageSent', (data) {
//       final msg = ChatMessage.fromJson(Map<String, dynamic>.from(data));
//       if (_currentChatUserId == msg.receiverId || _currentChatUserId == msg.senderId) {
//         state = [...state, msg];
//       }
//     });

//     // Incoming from peer
//     _socket.on('receiveMessage', (data) {
//       final msg = ChatMessage.fromJson(Map<String, dynamic>.from(data));
//       if (_currentChatUserId == msg.senderId || _currentChatUserId == msg.receiverId) {
//         state = [...state, msg];
//       }
//     });

//     // History load
//     _socket.on('chatHistory', (data) {
//       final list = (data['messages'] as List)
//           .map((m) => ChatMessage.fromJson(Map<String, dynamic>.from(m)))
//           .toList();
//       state = list;
//     });

//     // ---------- Typing ----------
//     _socket.on('typing', (data) {
//       // { from, at }
//       final from = data['from'];
//       if (from == _activePeer) {
//         _ref.read(typingProvider.notifier).state = true;
//         _typingHideTimer?.cancel();
//         _typingHideTimer = Timer(const Duration(seconds: 2), () {
//           _ref.read(typingProvider.notifier).state = false;
//         });
//       }
//     });

//     // ---------- Presence (optional; only if backend implemented) ----------
//     _socket.on('presence', (data) {
//       // { userId, online, lastSeen? }
//       if (data['userId'] == _activePeer) {
//         final online = data['online'] == true;
//         DateTime? last;
//         if (data['lastSeen'] != null) {
//           last = DateTime.parse(data['lastSeen']);
//         }
//         _ref.read(presenceProvider.notifier).state =
//             (online: online, lastSeen: last);
//       }
//     });

//     _socket.on('presenceBatch', (map) {
//       if (_activePeer == null) return;
//       final p = map['$_activePeer'];
//       if (p == null) return;
//       final online = p['online'] == true;
//       DateTime? last =
//           p['lastSeen'] == null ? null : DateTime.parse(p['lastSeen']);
//       _ref.read(presenceProvider.notifier).state =
//           (online: online, lastSeen: last);
//     });

//     _socket.onDisconnect((_) {
//       // print("🔌 Chat socket disconnected");
//     });

//     _initialized = true;
//   }

//   /// Load conversation and request presence (if backend supports it)
//   void fetchMessages(int withUserId) {
//     _currentChatUserId = withUserId;
//     _activePeer = withUserId;

//     _socket.emit('fetchMessages', {'withUserId': withUserId});

//     // Ask for presence information (no-op if backend doesn't have it)
//     _socket.emit('getPresence', {'userIds': [withUserId]});
//   }

//   void sendMessage(int receiverId, String message) {
//     _socket.emit('sendMessage', {
//       'receiverId': receiverId,
//       'message': message,
//     });
//   }

//   /// Call this on text-field change to ping "typing" to the peer.
//   void sendTyping(int toUserId) {
//     _socket.emit('typing', {'to': toUserId});
//   }

//   @override
//   void dispose() {
//     _typingHideTimer?.cancel();
//     _socket.dispose();
//     super.dispose();
//   }
// }













import 'dart:async';
import 'package:dating/model/chat_message.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

/// UI flags
final typingProvider = StateProvider<bool>((_) => false);

/// Presence (only useful if your backend emits it)
final presenceProvider =
    StateProvider<({bool online, DateTime? lastSeen})?>((_) => null);

/// PROVIDER
final chatProvider =
    StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
  return ChatNotifier(ref);
});

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  final Ref _ref;

  IO.Socket? _socket;
  String? _token;

  bool _connected = false;
  bool _refreshing = false;

  int? _currentChatUserId; // who we're chatting with (route-level)
  int? _activePeer;        // same as _currentChatUserId, used in handlers

  Timer? _typingHideTimer;

  ChatNotifier(this._ref) : super([]) {
    // Start with current token
    _token = _ref.read(loginProvider).data?.first.accessToken;

    // If token changes anywhere else (e.g., REST refresh), reconnect socket
    _ref.listen(loginProvider, (prev, next) {
      final newTok = next.data?.first.accessToken;
      if (newTok != null && newTok.isNotEmpty && newTok != _token) {
        _token = newTok;
        _reconnectWithToken(newTok);
      }
    });

    _connect();
  }

  // ---------------- lifecycle ----------------

  void _connect() {
    final token = _token;
    if (token == null || token.isEmpty) {
      print("❌ Chat socket: no access token yet.");
      return;
    }

    print('🧠 Connecting Chat socket with token...');
    _socket = IO.io(
      'ws://97.74.93.26:6100',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})   // send token here
          .enableForceNew()
          .enableReconnection()        // library auto-retry (network hiccups)
          .build(),
    );

    _wireEvents();
    _socket!.connect();
  }

  void _wireEvents() {
    _socket!.onConnect((_) {
      _connected = true;
      // print("✅ Chat socket connected");
      // If we already have an open chat, re-fetch it after reconnect
      if (_currentChatUserId != null) {
        // short delay so server is ready for emits
        Future.delayed(const Duration(milliseconds: 200), () {
          _refetchActiveChat();
        });
      }
    });

    // Self confirmation
    _socket!.on('messageSent', (data) {
      final msg = ChatMessage.fromJson(Map<String, dynamic>.from(data));
      if (_currentChatUserId == msg.receiverId || _currentChatUserId == msg.senderId) {
        state = [...state, msg];
      }
    });

    // Incoming from peer
    _socket!.on('receiveMessage', (data) {
      final msg = ChatMessage.fromJson(Map<String, dynamic>.from(data));
      if (_currentChatUserId == msg.senderId || _currentChatUserId == msg.receiverId) {
        state = [...state, msg];
      }
    });

    // History load
    _socket!.on('chatHistory', (data) {
      try {
        final list = (data['messages'] as List)
            .map((m) => ChatMessage.fromJson(Map<String, dynamic>.from(m)))
            .toList();
        state = list;
      } catch (e) {
        print("❌ chatHistory parse error: $e");
      }
    });

    // ---------- Typing ----------
    _socket!.on('typing', (data) {
      final from = data['from'];
      if (from == _activePeer) {
        _ref.read(typingProvider.notifier).state = true;
        _typingHideTimer?.cancel();
        _typingHideTimer = Timer(const Duration(seconds: 2), () {
          _ref.read(typingProvider.notifier).state = false;
        });
      }
    });

    // ---------- Presence (optional) ----------
    _socket!.on('presence', (data) {
      if (data['userId'] == _activePeer) {
        final online = data['online'] == true;
        DateTime? last =
            data['lastSeen'] == null ? null : DateTime.parse(data['lastSeen']);
        _ref.read(presenceProvider.notifier).state =
            (online: online, lastSeen: last);
      }
    });

    _socket!.on('presenceBatch', (map) {
      if (_activePeer == null) return;
      final p = map['$_activePeer'];
      if (p == null) return;
      final online = p['online'] == true;
      DateTime? last =
          p['lastSeen'] == null ? null : DateTime.parse(p['lastSeen']);
      _ref.read(presenceProvider.notifier).state =
          (online: online, lastSeen: last);
    });

    // ---------- Token/auth errors ----------
    _socket!.onError((err) => _handleAuthErrorIfAny(err));
    _socket!.onConnectError((err) => _handleAuthErrorIfAny(err));
    _socket!.on('unauthorized', (err) => _handleAuthErrorIfAny(err)); // if server emits this

    _socket!.onDisconnect((_) {
      _connected = false;
      // print("🔌 Chat socket disconnected");
    });
  }

  void _handleAuthErrorIfAny(dynamic err) async {
    final msg = (err ?? '').toString().toLowerCase();
    final unauthorized = msg.contains('401') ||
        msg.contains('unauthorized') ||
        msg.contains('invalid token') ||
        msg.contains('token expired');

    if (!unauthorized) {
      // Non-auth error; let auto-reconnect handle it.
      print('ℹ️ Chat socket non-auth error: $err');
      return;
    }

    if (_refreshing) return; // prevent parallel refreshes
    _refreshing = true;

    try {
      print('🔐 Chat socket: token invalid. Refreshing...');
      final newAccess =
          await _ref.read(loginProvider.notifier).restoreAccessToken();
      if (newAccess.isEmpty) {
        print('❌ Chat socket: refresh failed.');
        return;
      }
      // Either the loginProvider listener will reconnect, or force it here:
      await _reconnectWithToken(newAccess);
    } catch (e) {
      print('❌ Chat socket refresh flow failed: $e');
    } finally {
      _refreshing = false;
    }
  }

  Future<void> _reconnectWithToken(String newToken) async {
    print('♻️ Chat socket: reconnecting with new token...');
    _teardown();
    _token = newToken;
    _connect();

    // Re-request current chat & presence once connected
    Future.delayed(const Duration(milliseconds: 300), _refetchActiveChat);
  }

  void _refetchActiveChat() {
    final withUserId = _currentChatUserId;
    if (withUserId == null || !_connected) return;
    _socket?.emit('fetchMessages', {'withUserId': withUserId});
    _socket?.emit('getPresence', {'userIds': [withUserId]});
  }

  void _teardown() {
    try {
      _socket?.off('messageSent');
      _socket?.off('receiveMessage');
      _socket?.off('chatHistory');
      _socket?.off('typing');
      _socket?.off('presence');
      _socket?.off('presenceBatch');
      _socket?.off('unauthorized');
      _socket?.offAny();
      _socket?.dispose();
    } catch (_) {}
    _socket = null;
    _connected = false;
  }

  // ---------------- public API ----------------

  /// Load conversation and request presence
  void fetchMessages(int withUserId) {
    _currentChatUserId = withUserId;
    _activePeer = withUserId;

    _socket?.emit('fetchMessages', {'withUserId': withUserId});
    _socket?.emit('getPresence', {'userIds': [withUserId]});
  }

  void sendMessage(int receiverId, String message) {
    _socket?.emit('sendMessage', {
      'receiverId': receiverId,
      'message': message,
      'type': 'text',
    });
  }

  /// NEW: Send image message with optional caption
  void sendImageMessage({
    required int receiverId,
    required List<String> media,
    String? message,
  }) {
    _socket?.emit('sendMessage', {
      'receiverId': receiverId,
      'media': media,
      'message': message,
      'type': 'image',
    });
  }

  /// Call this on text-field change to ping "typing" to the peer.
  void sendTyping(int toUserId) {
    _socket?.emit('typing', {'to': toUserId});
  }

  @override
  void dispose() {
    _typingHideTimer?.cancel();
    _teardown();
    super.dispose();
  }
}