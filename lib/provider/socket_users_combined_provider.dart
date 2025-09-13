// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:dating/provider/loginProvider.dart';

// final socketUserProvider =
//     StateNotifierProvider<SocketUserNotifier, List<Map<String, dynamic>>>((ref) {
//   final accessToken = ref.read(loginProvider).data?.first.accessToken;
//   print("from socket-----$accessToken");
//   if (accessToken == null) {
//     throw Exception("Access token is null");
//   }
//   return SocketUserNotifier(accessToken);
// });

// class SocketUserNotifier extends StateNotifier<List<Map<String, dynamic>>> {
//   final String accessToken;
//   late IO.Socket socket;
//   int _page = 1;
//   bool _connected = false;
//   bool _isFetching = false;

//   SocketUserNotifier(this.accessToken) : super([]) {
//     _initSocket();
//   }

//   void _initSocket() {
//     try {
//       print('🧠 Connecting to socket with token: $accessToken');

//       socket = IO.io('ws://97.74.93.26:6100', IO.OptionBuilder()
//           .setTransports(['websocket'])
//           .setAuth({'token': accessToken})
//           .enableForceNew()
//           .enableReconnection()
//           .build());

//       socket.onConnect((_) {
//         _connected = true;
//         print('✅ Connected to socket');
//         fetchPage(1); // Load initial page
//       });

//       socket.on('availableUsersData', (data) {
//         try {
//           print('📦 Data from socket: $data');

//           if (data is! Map || !data.containsKey('data')) {
//             print("❗ Unexpected socket response format.");
//             return;
//           }

//           final List users = data['data'] ?? [];
//           print("📊 Users received: ${users.length}");

//           state = [...state, ...users.map((e) => Map<String, dynamic>.from(e))];
//           _isFetching = false;
//         } catch (e) {
//           print("❌ Error parsing availableUsersData: $e");
//         }
//       });

//       socket.onConnectError((err) {
//         print('❌ Socket connection error: $err');
//       });

//       socket.onDisconnect((_) {
//         _connected = false;
//         print('🔌 Disconnected from socket');
//       });

//       socket.onAny((event, data) {
//         print("📡 [Socket Event] $event => $data");
//       });

//       socket.connect();
//     } catch (e) {
//       print("❌ Exception during socket initialization: $e");
//     }
//   }

//   void fetchPage(int page) {
//     try {
//       if (!_connected || _isFetching) {
//         print("⚠️ Skipping fetch. Connected: $_connected, Fetching: $_isFetching");
//         return;
//       }
//       _isFetching = true;
//       print("📤 Emitting getAvailableUsers for page $page");
//       socket.emit('getAvailableUsers', {'page': page});
//     } catch (e) {
//       print("❌ Exception in fetchPage: $e");
//     }
//   }

//   void fetchNextPageIfNearEnd(int currentIndex) {
//     try {
//       if (state.length >= 30 && currentIndex >= state.length - 5) {
//         _page++;
//         fetchPage(_page);
//       }
//     } catch (e) {
//       print("❌ Exception in fetchNextPageIfNearEnd: $e");
//     }
//   }

//   void reset() {
//     try {
//       print("🔄 Resetting user state and fetching page 1");
//       state = [];
//       _page = 1;
//       fetchPage(_page);
//     } catch (e) {
//       print("❌ Exception in reset: $e");
//     }
//   }
// }








import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:dating/provider/loginProvider.dart'; // exposes loginProvider + restoreAccessToken()

// PROVIDER
final socketUserProvider = StateNotifierProvider<SocketUserNotifier, List<Map<String, dynamic>>>(
  (ref) => SocketUserNotifier(ref),
);

class SocketUserNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final Ref ref;
  IO.Socket? _socket;
  String? _token;
  int _page = 1;
  bool _connected = false;
  bool _isFetching = false;
  bool _refreshing = false;

  SocketUserNotifier(this.ref) : super([]) {
    // 1) Start with whatever token we have now
    _token = ref.read(loginProvider).data?.first.accessToken;

    // 2) If the token ever changes (after refresh), reconnect with the new one
    ref.listen(loginProvider, (prev, next) {
      final newTok = next.data?.first.accessToken;
      if (newTok != null && newTok.isNotEmpty && newTok != _token) {
        _token = newTok;
        _reconnectWithToken(newTok);
      }
    });

    _connect();
  }

  // ------------ public methods ------------
  void fetchPage(int page) {
    if (!_connected || _isFetching) {
      print("⚠️ Skipping fetch. Connected: $_connected, Fetching: $_isFetching");
      return;
    }
    _isFetching = true;
    print("📤 Emitting getAvailableUsers for page $page");
    _socket?.emit('getAvailableUsers', {'page': page});
  }

  void fetchNextPageIfNearEnd(int currentIndex) {
    if (state.length >= 30 && currentIndex >= state.length - 5) {
      _page++;
      fetchPage(_page);
    }
  }

  void reset() {
    print("🔄 Resetting user state and fetching page 1");
    state = [];
    _page = 1;
    fetchPage(_page);
  }

  @override
  void dispose() {
    _teardown();
    super.dispose();
  }

  // ------------ internals ------------
  void _connect() {
    final token = _token;
    if (token == null || token.isEmpty) {
      print("❌ No access token available for socket yet.");
      return;
    }

    print('🧠 Connecting to socket with token: $token');

    _socket = IO.io(
      'ws://97.74.93.26:6100', // your server
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})       // <-- send token here
          .enableForceNew()
          .enableReconnection()
          .build(),
    );

    _socket!.onConnect((_) {
      _connected = true;
      print('✅ Connected to socket');
      if (state.isEmpty) fetchPage(1);
    });

    _socket!.on('availableUsersData', (data) {
      try {
        print('📦 Data from socket: $data');
        if (data is! Map || !data.containsKey('data')) {
          print("❗ Unexpected socket response format.");
          _isFetching = false;
          return;
        }
        final List users = data['data'] ?? [];
        state = [...state, ...users.map((e) => Map<String, dynamic>.from(e))];
        _isFetching = false;
      } catch (e) {
        print("❌ Error parsing availableUsersData: $e");
        _isFetching = false;
      }
    });

    // If the server rejects auth at any point, we handle it:
    _socket!.onError((err) => _handleAuthErrorIfAny(err));
    _socket!.onConnectError((err) => _handleAuthErrorIfAny(err));
    _socket!.on('unauthorized', (err) => _handleAuthErrorIfAny(err)); // if your server emits this

    _socket!.onDisconnect((_) {
      _connected = false;
      print('🔌 Disconnected from socket');
    });

    _socket!.connect();
  }

  /// Looks for “401/unauthorized/token expired” and triggers refresh+reconnect
  void _handleAuthErrorIfAny(dynamic err) async {
    final msg = (err ?? '').toString().toLowerCase();
    final looksUnauthorized = msg.contains('401') ||
        msg.contains('unauthorized') ||
        msg.contains('invalid token') ||
        msg.contains('token expired');

    if (!looksUnauthorized) {
      print('ℹ️ Socket error (non-auth): $err');
      return;
    }

    if (_refreshing) return; // prevent multiple parallel refreshes
    _refreshing = true;

    try {
      print('🔐 Token invalid on socket. Refreshing...');
      final newAccess = await ref.read(loginProvider.notifier).restoreAccessToken();
      if (newAccess.isEmpty) {
        print('❌ Refresh failed. Cannot reconnect socket.');
        return;
      }
      // Either the ref.listen above will catch token change and reconnect,
      // or we explicitly force it here:
      await _reconnectWithToken(newAccess);
    } catch (e) {
      print('❌ Socket refresh flow failed: $e');
    } finally {
      _refreshing = false;
    }
  }

  Future<void> _reconnectWithToken(String newToken) async {
    print('♻️ Reconnecting socket with new token...');
    _teardown();             // fully close old socket
    _token = newToken;
    _connect();              // connect with new token

    // optional: resume the page you were on
    Future.delayed(const Duration(milliseconds: 300), () {
      if (state.isEmpty) {
        fetchPage(1);
      } else {
        fetchPage(_page == 0 ? 1 : _page);
      }
    });
  }

  void _teardown() {
    try {
      _socket?.off('availableUsersData');
      _socket?.off('unauthorized');
      _socket?.offAny();
      _socket?.dispose(); // closes the channel
    } catch (_) {}
    _socket = null;
    _connected = false;
    _isFetching = false;
  }
}
