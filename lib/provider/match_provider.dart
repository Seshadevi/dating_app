
import 'package:dating/model/MatchUserModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'loginProvider.dart';

final matchProvider = StateNotifierProvider<MatchNotifier, List<MatchUserModel>>((ref) {
  final accessToken = ref.read(loginProvider).data?.first.accessToken;
  if (accessToken == null) {
    throw Exception("Access token is null. Cannot initialize chat.");
  }
  return MatchNotifier(accessToken);
});

class MatchNotifier extends StateNotifier<List<MatchUserModel>> {
  final String accessToken;
  late IO.Socket socket;

  MatchNotifier(this.accessToken) : super([]) {
    _initSocket();
  }

  void _initSocket() {
    socket = IO.io('ws://97.74.93.26:6100', IO.OptionBuilder()
      .setTransports(['websocket'])
      .setAuth({ 'token': accessToken })
      .build());

    socket.onConnect((_) {
      print('🧠 Connected to match socket');
      socket.emit('getMyMatches');
    });

    socket.on('myMatches', (data) {
      print("🎯 myMatches received: \$data");
      final matches = (data['matches'] as List)
          .map((e) => MatchUserModel.fromJson(e))
          .toList();
      state = matches;
    });

    socket.onConnectError((e) => print('❌ Connection error: \$e'));
    socket.onDisconnect((_) => print('🔌 Disconnected from match socket'));
  }
} 