import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:dating/provider/loginProvider.dart';

final socketUserProvider =
    StateNotifierProvider<SocketUserNotifier, List<Map<String, dynamic>>>((ref) {
  final accessToken = ref.read(loginProvider).data?.first.accessToken;
  print("from socket-----$accessToken");
  if (accessToken == null) {
    throw Exception("Access token is null");
  }
  return SocketUserNotifier(accessToken);
});

class SocketUserNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final String accessToken;
  late IO.Socket socket;
  int _page = 1;
  bool _connected = false;
  bool _isFetching = false;

  SocketUserNotifier(this.accessToken) : super([]) {
    _initSocket();
  }

  void _initSocket() {
    try {
      print('🧠 Connecting to socket with token: $accessToken');

      socket = IO.io('ws://97.74.93.26:6100', IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': accessToken})
          .enableForceNew()
          .enableReconnection()
          .build());

      socket.onConnect((_) {
        _connected = true;
        print('✅ Connected to socket');
        fetchPage(1); // Load initial page
      });

      socket.on('availableUsersData', (data) {
        try {
          print('📦 Data from socket: $data');

          if (data is! Map || !data.containsKey('data')) {
            print("❗ Unexpected socket response format.");
            return;
          }

          final List users = data['data'] ?? [];
          print("📊 Users received: ${users.length}");

          state = [...state, ...users.map((e) => Map<String, dynamic>.from(e))];
          _isFetching = false;
        } catch (e) {
          print("❌ Error parsing availableUsersData: $e");
        }
      });

      socket.onConnectError((err) {
        print('❌ Socket connection error: $err');
      });

      socket.onDisconnect((_) {
        _connected = false;
        print('🔌 Disconnected from socket');
      });

      socket.onAny((event, data) {
        print("📡 [Socket Event] $event => $data");
      });

      socket.connect();
    } catch (e) {
      print("❌ Exception during socket initialization: $e");
    }
  }

  void fetchPage(int page) {
    try {
      if (!_connected || _isFetching) {
        print("⚠️ Skipping fetch. Connected: $_connected, Fetching: $_isFetching");
        return;
      }
      _isFetching = true;
      print("📤 Emitting getAvailableUsers for page $page");
      socket.emit('getAvailableUsers', {'page': page});
    } catch (e) {
      print("❌ Exception in fetchPage: $e");
    }
  }

  void fetchNextPageIfNearEnd(int currentIndex) {
    try {
      if (state.length >= 30 && currentIndex >= state.length - 5) {
        _page++;
        fetchPage(_page);
      }
    } catch (e) {
      print("❌ Exception in fetchNextPageIfNearEnd: $e");
    }
  }

  void reset() {
    try {
      print("🔄 Resetting user state and fetching page 1");
      state = [];
      _page = 1;
      fetchPage(_page);
    } catch (e) {
      print("❌ Exception in reset: $e");
    }
  }
}




// // 📦 socket_users_combined_provider.dart
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:dating/provider/loginProvider.dart';

// final socketUserProvider =
//     StateNotifierProvider<SocketUserNotifier, List<Map<String, dynamic>>>((ref) {
//   final accessToken = ref.read(loginProvider).data![0].accessToken;

//   print("🧠 Connecting socket with token: $accessToken");

//   final socket = IO.io(
//     'ws://97.74.93.26:6100',
//     IO.OptionBuilder()
//         .setTransports(['websocket'])
//         .setAuth({'token': accessToken})
//         // .enableForceNew()
//         // .enableReconnection()
//         // .build(),
//   );

//   socket.connect();

//   ref.onDispose(() {
//     socket.disconnect();
//   });

//   return SocketUserNotifier(socket);
// });

// class SocketUserNotifier extends StateNotifier<List<Map<String, dynamic>>> {
//   final IO.Socket socket;
//   int _page = 1;
//   int _totalPages = 1;
//   bool _isFetching = false;
//   bool _connected = false;

//   SocketUserNotifier(this.socket) : super([]) {
//     _initSocketListeners();
//     // _fetchPage(_page); // Load first page
//   }

//   void _initSocketListeners() {
//     print("🧩 Socket ID: \${socket.id}");

//     socket.onConnect((_) {
//       _connected = true;
//       print("✅ Socket connected: \${socket.id}, fetching page 1");
//       _fetchPage(1);
//     });

//     socket.on('availableUsersData', (data) {
//       try {
//         final List users = data['data'] ?? [];
//         final pagination = data['pagination'];
//         _page = pagination['page'];
//         _totalPages = pagination['totalPages'];

//         if (users.isEmpty) {
//           print("⚠️ Received empty user list for page $_page");
//         } else {
//           print("✅ Received \${users.length} users for page $_page");
//         }

//         state = [...state, ...users.map((e) => Map<String, dynamic>.from(e))];
//         _isFetching = false;
//       } catch (e) {
//         print("❌ Error parsing socket user data: \$e");
//       }
//     });

//     socket.onConnectError((err) {
//       print("❌ Socket connection error: \$err");
//     });

//     socket.onDisconnect((_) {
//       _connected = false;
//       print("🔌 Socket disconnected.");
//     });
//   }

//   void _fetchPage(int page) {
//     if (_isFetching || !_connected || page > _totalPages) {
//       if (!_connected) print("⚠️ Socket not connected. Cannot fetch page \$page.");
//       return;
//     }

//     print("📤 Emitting getAvailableUsers for page \$page");
//     _isFetching = true;
//     socket.emit('getAvailableUsers', {'page': page});
//   }

//   void fetchNextPageIfNeeded(int currentIndex) {
//     if (state.length >= 30 && currentIndex >= state.length - 5) {
//       _fetchPage(_page + 1);
//     }
//   }

//   void reset() {
//     print("🔁 Resetting socket user state.");
//     _page = 1;
//     _totalPages = 1;
//     _isFetching = false;
//     state = [];
//     _fetchPage(1);
//   }
// }











// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:dating/provider/loginProvider.dart';

// final socketProvider = Provider<IO.Socket>((ref) {
//   final accessToken = ref.read(loginProvider).data![0].accessToken;

//   if (accessToken == null || accessToken.isEmpty) {
//     throw Exception("Access token not available");
//   }

//   final socket = IO.io(
//     'http://97.74.93.26:6100',
//     IO.OptionBuilder()
//       .setTransports(['websocket']) // use WebSocket only
//       .setAuth({'token': accessToken}) // pass JWT here
//       .enableForceNew()
//       .enableReconnection()
//       .build(),
//   );

//   socket.connect();

//   ref.onDispose(() {
//     socket.disconnect();
//   });

//   return socket;
// });







// // lib/provider/socket/web_socket_provider.dart
// import 'package:dating/provider/loginProvider.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:web_socket_channel/status.dart' as status;


// final webSocketProvider = Provider<WebSocketChannel>((ref) {
//   final accessToken = ref.read(loginProvider).data![0].accessToken;

//   if (accessToken == null || accessToken.isEmpty) {
//     throw Exception("Access token not available");
//   }

//   final uri = Uri.parse(
//     'ws://97.74.93.26:6100/test/testLikeandPurchase.html?token=$accessToken',
//   );

//   final channel = WebSocketChannel.connect(uri);

//   ref.onDispose(() {
//     channel.sink.close(status.goingAway);
//   });

//   return channel;
// });
