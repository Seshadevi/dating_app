import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// 🔁 your existing login provider (must expose .data?.first.accessToken
// and a .restoreAccessToken() that returns a fresh access token string)
import 'package:dating/provider/loginProvider.dart';

const _wsUrl = 'ws://97.74.93.26:6100';

final meRawProvider =
    StateNotifierProvider<MeRawNotifier, AsyncValue<Map<String, dynamic>?>>(
  (ref) => MeRawNotifier(ref),
);

class MeRawNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  final Ref ref;
  IO.Socket? _socket;
  String? _token;
  bool _refreshing = false;

  MeRawNotifier(this.ref) : super(const AsyncValue.loading()) {
    _token = ref.read(loginProvider).data?.first.accessToken;

    // When login state changes (e.g., token refresh elsewhere), reconnect.
    ref.listen(loginProvider, (prev, next) async {
      final t = next.data?.first.accessToken;
      if (t != null && t.isNotEmpty && t != _token) {
        _token = t;
        await _reconnect();
      }
    });

    _connect();
  }

  void _connect() {
    final t = _token;
    if (t == null || t.isEmpty) {
      state = const AsyncValue.error('No access token', StackTrace.empty);
      return;
    }

    _socket = IO.io(
      _wsUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': t})
          .enableForceNew()
          .enableReconnection()
          .build(),
    );

    _socket!.onConnect((_) => _socket?.emit('getMe'));

    _socket!.on('me', (payload) {
      try {
        final data = (payload is Map && payload['data'] != null)
            ? Map<String, dynamic>.from(payload['data'])
            : <String, dynamic>{};
        state = AsyncValue.data(data);
      } catch (e, st) {
        state = AsyncValue.error('Failed to parse profile', st);
      }
    });

    _socket!.on('chatError', (e) {
      final msg = (e is Map ? e['message'] : null) ?? 'Error';
      state = AsyncValue.error(msg, StackTrace.empty);
    });

    // Handle auth errors -> try refresh -> reconnect
    void _maybeAuthError(dynamic err) async {
      final msg = (err ?? '').toString().toLowerCase();
      final unauthorized = msg.contains('401') ||
          msg.contains('unauthorized') ||
          msg.contains('invalid token') ||
          msg.contains('token expired');

      if (!unauthorized || _refreshing) return;
      _refreshing = true;
      try {
        final newAccess = await ref.read(loginProvider.notifier).restoreAccessToken();
        if (newAccess.isNotEmpty) {
          _token = newAccess;
          await _reconnect();
        } else {
          state = const AsyncValue.error('Session expired. Please log in again.', StackTrace.empty);
        }
      } finally {
        _refreshing = false;
      }
    }

    _socket!.onError(_maybeAuthError);
    _socket!.onConnectError(_maybeAuthError);
    _socket!.on('unauthorized', _maybeAuthError);

    _socket!.connect();
  }

  Future<void> _reconnect() async {
    try {
      _socket?.off('me');
      _socket?.off('chatError');
      _socket?.offAny();
      _socket?.dispose();
    } catch (_) {}
    _socket = null;
    _connect();
    // re-fetch
    Future.delayed(const Duration(milliseconds: 250), () => _socket?.emit('getMe'));
  }

  void reload() => _socket?.emit('getMe');

  @override
  void dispose() {
    try {
      _socket?.offAny();
      _socket?.dispose();
    } catch (_) {}
    super.dispose();
  }
}
