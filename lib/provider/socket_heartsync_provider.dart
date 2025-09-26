import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:dating/provider/loginProvider.dart';
import '../model/socket_user_model.dart';

final socketUserProvider = StateNotifierProvider<SocketUserNotifier, SocketUserResponse?>(
      (ref) => SocketUserNotifier(ref),
);

class SocketUserNotifier extends StateNotifier<SocketUserResponse?> {
  final Ref ref;
  IO.Socket? _socket;
  String? _token;
  int _page = 1;
  bool _connected = false;
  bool _isFetching = false;
  bool _refreshing = false;

  SocketUserNotifier(this.ref) : super(null) {
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

  // Getter methods for easy access
  List<Data> get users => state?.data ?? [];
  Pagination? get pagination => state?.pagination;
  List<int>? get modeFilter => state?.modeFilter;
  ModeFilterMeta? get modeFilterMeta => state?.modeFilterMeta;
  bool get hasUsers => users.isNotEmpty;
  int get totalUsers => users.length;
  bool get isConnected => _connected;
  bool get isFetching => _isFetching;
  int get currentPage => _page;

  // Get user by index
  Data? getUserAt(int index) {
    if (index >= 0 && index < users.length) {
      return users[index];
    }
    return null;
  }

  // Get user by ID
  Data? getUserById(int id) {
    return users.where((user) => user.id == id).firstOrNull;
  }

  // Remove user by ID (useful for blocking/hiding users)
  void removeUser(int userId) {
    if (state != null && state!.data != null) {
      final updatedUsers = users.where((user) => user.id != userId).toList();
      state = SocketUserResponse(
        data: updatedUsers,
        pagination: state!.pagination,
        modeFilter: state!.modeFilter,
        modeFilterMeta: state!.modeFilterMeta,
      );
    }
  }

  // Update specific user data
  void updateUser(Data updatedUser) {
    if (state != null && state!.data != null) {
      final updatedUsers = users.map((user) {
        if (user.id == updatedUser.id) {
          return updatedUser;
        }
        return user;
      }).toList();

      state = SocketUserResponse(
        data: updatedUsers,
        pagination: state!.pagination,
        modeFilter: state!.modeFilter,
        modeFilterMeta: state!.modeFilterMeta,
      );
    }
  }

  void fetchPage(int page) {
    if (!_connected || _isFetching) return;
    _isFetching = true;
    _socket?.emit('getAvailableUsers', {'page': page});
  }

  void fetchNextPageIfNeeded(int currentIndex) {
    if (users.length >= 30 && currentIndex >= users.length - 5) {
      final nextPage = (pagination?.page ?? 0) + 1;
      final totalPages = pagination?.totalPages ?? 0;

      if (nextPage <= totalPages) {
        _page = nextPage;
        fetchPage(_page);
      }
    }
  }

  void reset() {
    state = null;
    _page = 1;
    fetchPage(_page);
  }

  // Refresh current data
  void refresh() {
    final currentPageToRefresh = pagination?.page ?? 1;
    state = null;
    _page = 1;
    fetchPage(currentPageToRefresh);
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
      print('Socket connected successfully');
      _connected = true;
      if (!hasUsers) fetchPage(1);
    });

    _socket!.on('availableUsersData', (data) {
      print('Received availableUsersData: $data');
      try {
        if (data is Map<String, dynamic>) {
          final socketResponse = SocketUserResponse.fromJson(data);

          if (state == null) {
            // First time loading
            state = socketResponse;
            print('Initial data loaded: ${users.length} users');
          } else {
            // Append new users for pagination
            final currentUsers = List<Data>.from(users);
            final newUsers = socketResponse.data ?? [];

            state = SocketUserResponse(
              data: [...currentUsers, ...newUsers],
              pagination: socketResponse.pagination,
              modeFilter: socketResponse.modeFilter,
              modeFilterMeta: socketResponse.modeFilterMeta,
            );
            print('Appended ${newUsers.length} users, total: ${users.length}');
          }
        }
      } catch (e) {
        print('Error parsing socket response: $e');
      }
      _isFetching = false;
    });

    _socket!.onError((error) {
      print('Socket error: $error');
      _handleSocketError(error);
    });

    _socket!.onConnectError((error) {
      print('Socket connect error: $error');
      _handleSocketError(error);
    });

    _socket!.on('unauthorized', (error) {
      print('Socket unauthorized: $error');
      _handleSocketError(error);
    });

    _socket!.onDisconnect((reason) {
      print('Socket disconnected: $reason');
      _connected = false;
    });

    _socket!.onReconnect((data) {
      print('Socket reconnected: $data');
      _connected = true;
    });

    _socket!.connect();
  }

  void _handleSocketError(dynamic error) async {
    final errStr = (error ?? '').toString().toLowerCase();
    bool unauthorized = errStr.contains('401') ||
        errStr.contains('unauthorized') ||
        errStr.contains('token');

    if (!unauthorized) return;

    if (_refreshing) return;
    _refreshing = true;

    try {
      print('Attempting to refresh access token...');
      final newToken = await ref.read(loginProvider.notifier).restoreAccessToken();
      if (newToken.isNotEmpty) {
        print('New token obtained, reconnecting...');
        _reconnectWithToken(newToken);
      }
    } catch (e) {
      print('Failed to refresh token: $e');
    } finally {
      _refreshing = false;
    }
  }

  Future<void> _reconnectWithToken(String newToken) async {
    print('Reconnecting with new token...');
    _teardown();
    _token = newToken;
    _connect();

    // Wait a bit before fetching data
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!hasUsers) {
        fetchPage(1);
      } else {
        fetchPage(_page);
      }
    });
  }

  void _teardown() {
    try {
      _socket?.off('availableUsersData');
      _socket?.off('unauthorized');
      _socket?.offAny();
      _socket?.dispose();
    } catch (e) {
      print('Error during socket teardown: $e');
    }
    _socket = null;
    _connected = false;
    _isFetching = false;
  }
}
