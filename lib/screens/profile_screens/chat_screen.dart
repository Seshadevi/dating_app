import 'dart:async';
import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/model/chat_message.dart';
import 'package:dating/provider/chat_socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';


class ChatScreen extends ConsumerStatefulWidget {
  final int matchId;
  final int userId;
  final String userName;
  final String avatar;

  const ChatScreen({
    Key? key,
    required this.matchId,
    required this.userId,
    required this.userName,
    required this.avatar,
  }) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _typingDebounce;

  @override
  void initState() {
    super.initState();
    ref.read(chatProvider.notifier).fetchMessages(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider);
    final isTyping = ref.watch(typingProvider);
    final presence = ref.watch(presenceProvider);

    final items = _withDateHeaders(messages);

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(widget.avatar)),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.userName, style: const TextStyle(fontSize: 16)),
                Text(
                  presence == null
                    ? ''
                    : presence.online
                      ? 'Online'
                      : (presence.lastSeen != null
                          ? 'last seen ${DateFormat('dd MMM, hh:mm a').format(presence.lastSeen!)}'
                          : 'Offline'),
                  style: TextStyle(fontSize: 12, color: presence?.online == true ? Colors.green : Colors.grey),
                )
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final it = items[i];
                if (it.isHeader) {
                  return _DateHeader(label: it.header!);
                }
                final msg = it.message!;
                final isMe = msg.senderId != widget.userId;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFFD1F7C4) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E5E5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(msg.message),
                        const SizedBox(height: 4),
                        Text(DateFormat('hh:mm a').format(msg.timestamp.toLocal()),
                            style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (isTyping)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text('typing…', style: TextStyle(color: Colors.green[700], fontSize: 12)),
            ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type a message…",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onChanged: (_) {
                      // Debounce typing pings
                      _typingDebounce?.cancel();
                      ref.read(chatProvider.notifier).sendTyping(widget.userId);
                      _typingDebounce = Timer(const Duration(milliseconds: 1200), () {});
                    },
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send), onPressed: _sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final msg = _controller.text.trim();
    if (msg.isEmpty) return;
    ref.read(chatProvider.notifier).sendMessage(widget.userId, msg);
    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Build a mixed list of date headers + messages
  List<_Item> _withDateHeaders(List<ChatMessage> msgs) {
    final out = <_Item>[];
    DateTime? lastDay;
    for (final m in msgs..sort((a,b)=>a.timestamp.compareTo(b.timestamp))) {
      final d = DateTime(m.timestamp.year, m.timestamp.month, m.timestamp.day);
      if (lastDay == null || d.difference(lastDay!).inDays != 0) {
        out.add(_Item.header(_labelFor(d)));
        lastDay = d;
      }
      out.add(_Item.message(m));
    }
    return out;
  }

  String _labelFor(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yday = today.subtract(const Duration(days: 1));
    final day = DateTime(d.year, d.month, d.day);
    if (day == today) return 'Today';
    if (day == yday) return 'Yesterday';
    return DateFormat('dd MMM yyyy').format(d);
  }
}

class _DateHeader extends StatelessWidget {
  final String label;
  const _DateHeader({required this.label, super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12))),
    );
  }
}

class _Item {
  final bool isHeader;
  final String? header;
  final ChatMessage? message;
  _Item.header(this.header) : isHeader = true, message = null;
  _Item.message(this.message) : isHeader = false, header = null;
}
