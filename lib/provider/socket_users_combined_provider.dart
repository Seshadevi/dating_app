import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:dating/provider/loginProvider.dart';

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
    _token = ref.read(loginProvider).data?.first.accessToken;
    ref.listen(loginProvider, (prev, next) {
      final newTok = next.data?.first.accessToken;
      if (newTok != null && newTok.isNotEmpty && newTok != _token) {
        _token = newTok;
        _reconnectWithToken(newTok);
      }
    });
    _connect();
  }

  void fetchPage(int page) {
    if (!_connected || _isFetching) return;
    _isFetching = true;
    _socket?.emit('getAvailableUsers', {'page': page});
  }

  void fetchNextPageIfNeeded(int currentIndex) {
    if (state.length >= 30 && currentIndex >= state.length - 5) {
      _page++;
      fetchPage(_page);
    }
  }

  void reset() {
    state = [];
    _page = 1;
    fetchPage(_page);
  }

  @override
  void dispose() {
    _teardown();
    super.dispose();
  }

  void _connect() {
    if (_token == null || _token!.isEmpty) return;

    _socket = IO.io(
      'ws://97.74.93.26:6100',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': _token})
          .enableForceNew()
          .enableReconnection()
          .build(),
    );

   _socket!.onConnect((_) {
  _connected = true;
  if (state.isEmpty) fetchPage(1);
});


    _socket!.on('availableUsersData', (data) {
      try {
        if (data is Map && data.containsKey('data')) {
          final newUsers = data['data'] as List;
          state = [...state, ...newUsers.map((e) => Map<String, dynamic>.from(e))];
        }
      } catch (_) {}
      _isFetching = false;
    });

    _socket!.onError(_handleSocketError);
    _socket!.onConnectError(_handleSocketError);
    _socket!.on('unauthorized', _handleSocketError);

    _socket!.onDisconnect((_) {
      _connected = false;
    });


    _socket!.connect();
  }

  void _handleSocketError(dynamic error) async {
    final errStr = (error ?? '').toString().toLowerCase();
    bool unauthorized = errStr.contains('401') || errStr.contains('unauthorized') || errStr.contains('token');

    if (!unauthorized) return;

    if (_refreshing) return;
    _refreshing = true;
    try {
      final newToken = await ref.read(loginProvider.notifier).restoreAccessToken();
      if (newToken.isNotEmpty) _reconnectWithToken(newToken);
    } catch (_) {}
    finally {
      _refreshing = false;
    }
  }

  Future<void> _reconnectWithToken(String newToken) async {
    _teardown();
    _token = newToken;
    _connect();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (state.isEmpty) fetchPage(1);
      else fetchPage(_page);
    });
  }

  void _teardown() {
    try {
      _socket?.off('availableUsersData');
      _socket?.off('unauthorized');
      _socket?.offAny();
      _socket?.dispose();
    } catch (_) {}
    _socket = null;
    _connected = false;
    _isFetching = false;
  }
}