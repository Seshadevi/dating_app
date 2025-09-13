
// import 'package:dating/model/MatchUserModel.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// import 'loginProvider.dart';

// final matchProvider = StateNotifierProvider<MatchNotifier, List<MatchUserModel>>((ref) {
//   final accessToken = ref.read(loginProvider).data?.first.accessToken;
//   if (accessToken == null) {
//     throw Exception("Access token is null. Cannot initialize chat.");
//   }
//   return MatchNotifier(accessToken);
// });

// class MatchNotifier extends StateNotifier<List<MatchUserModel>> {
//   final String accessToken;
//   late IO.Socket socket;

//   MatchNotifier(this.accessToken) : super([]) {
//     _initSocket();
//   }

//   void _initSocket() {
//     socket = IO.io('ws://97.74.93.26:6100', IO.OptionBuilder()
//       .setTransports(['websocket'])
//       .setAuth({ 'token': accessToken })
//       .build());

//     socket.onConnect((_) {
//       print('🧠 Connected to match socket');
//       socket.emit('getMyMatches');
//     });

//     socket.on('myMatches', (data) {
//       print("🎯 myMatches received: \$data");
//       final matches = (data['matches'] as List)
//           .map((e) => MatchUserModel.fromJson(e))
//           .toList();
//       state = matches;
//     });

//     socket.onConnectError((e) => print('❌ Connection error: \$e'));
//     socket.onDisconnect((_) => print('🔌 Disconnected from match socket'));
//   }
// } 




import 'dart:async';
import 'package:dating/model/MatchUserModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'loginProvider.dart';

// PROVIDER
final matchProvider =
    StateNotifierProvider<MatchNotifier, List<MatchUserModel>>(
  (ref) => MatchNotifier(ref),
);

class MatchNotifier extends StateNotifier<List<MatchUserModel>> {
  final Ref ref;
  IO.Socket? _socket;
  String? _token;
  bool _connected = false;
  bool _refreshing = false;

  MatchNotifier(this.ref) : super([]) {
    // 1) start with current token
    _token = ref.read(loginProvider).data?.first.accessToken;

    // 2) if token changes (after refresh), reconnect with the new one
    ref.listen(loginProvider, (prev, next) {
      final newTok = next.data?.first.accessToken;
      if (newTok != null && newTok.isNotEmpty && newTok != _token) {
        _token = newTok;
        _reconnectWithToken(newTok);
      }
    });

    _connect();
  }

  // -------- socket lifecycle --------

  void _connect() {
    final token = _token;
    if (token == null || token.isEmpty) {
      print('❌ No access token for match socket.');
      return;
    }

    print('🧠 Connecting match socket with token...');
    _socket = IO.io(
      'ws://97.74.93.26:6100',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .enableForceNew()
          .enableReconnection()
          .build(),
    );

    // connected
    _socket!.onConnect((_) {
      _connected = true;
      print('✅ Connected to match socket');
      _socket?.emit('getMyMatches');
    });

    // matches payload
    _socket!.on('myMatches', (data) {
      try {
        print('🎯 myMatches received: $data');
        final list = (data is Map && data['matches'] is List)
            ? data['matches'] as List
            : (data is List ? data : const []);
        final matches = list.map((e) => MatchUserModel.fromJson(e)).toList();
        state = matches;
      } catch (e) {
        print('❌ Error parsing myMatches: $e');
      }
    });

    // auth/connection errors → try refresh
    _socket!.onError((err) => _handleAuthErrorIfAny(err));
    _socket!.onConnectError((err) => _handleAuthErrorIfAny(err));
    _socket!.on('unauthorized', (err) => _handleAuthErrorIfAny(err)); // if server emits this

    _socket!.onDisconnect((_) {
      _connected = false;
      print('🔌 Disconnected from match socket');
    });

    _socket!.connect();
  }

  void _handleAuthErrorIfAny(dynamic err) async {
    final msg = (err ?? '').toString().toLowerCase();
    final unauthorized = msg.contains('401') ||
        msg.contains('unauthorized') ||
        msg.contains('invalid token') ||
        msg.contains('token expired');

    if (!unauthorized) {
      print('ℹ️ Match socket non-auth error: $err');
      return;
    }

    if (_refreshing) return; // avoid parallel refreshes
    _refreshing = true;

    try {
      print('🔐 Token invalid on match socket. Refreshing...');
      final newAccess =
          await ref.read(loginProvider.notifier).restoreAccessToken();
      if (newAccess.isEmpty) {
        print('❌ Token refresh failed for match socket.');
        return;
      }
      // Either listener will catch and reconnect, or force it here:
      await _reconnectWithToken(newAccess);
    } catch (e) {
      print('❌ Match socket refresh flow failed: $e');
    } finally {
      _refreshing = false;
    }
  }

  Future<void> _reconnectWithToken(String newToken) async {
    print('♻️ Reconnecting match socket with new token...');
    _teardown();
    _token = newToken;
    _connect();

    // re-request matches shortly after connect
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_connected) _socket?.emit('getMyMatches');
    });
  }

  void _teardown() {
    try {
      _socket?.off('myMatches');
      _socket?.off('unauthorized');
      _socket?.offAny();
      _socket?.dispose();
    } catch (_) {}
    _socket = null;
    _connected = false;
  }

  @override
  void dispose() {
    _teardown();
    super.dispose();
  }
}
