import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/settings/dark_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dating/provider/match_provider.dart';
import 'package:dating/provider/chat_socket_provider.dart';
import 'package:dating/screens/profile_screens/chat_screen.dart';

import '../../model/MatchUserModel.dart';
import '../../model/chat_message.dart';

// Enhanced match model to include chat data
class MatchWithChatData {
  final MatchUserModel match;
  final String? lastMessage;
  final String? lastTimestamp;
  final int unreadCount;

  MatchWithChatData({
    required this.match,
    this.lastMessage,
    this.lastTimestamp,
    this.unreadCount = 0,
  });
}

// Provider to combine match data with chat info
final matchesWithChatProvider = Provider<List<MatchWithChatData>>((ref) {
  final matches = ref.watch(matchProvider);
  final chatMessages = ref.watch(chatProvider);

  // For now, return matches with placeholder chat data
  // You can enhance this to get real last messages from a chat history provider
  return matches.map((match) {
    // Find last message for this user (you'd implement this based on your chat storage)
    final lastMsg = _getLastMessageForUser(match.userId, chatMessages);

    return MatchWithChatData(
      match: match,
      lastMessage: lastMsg?.message ?? "Tap to start chatting",
      lastTimestamp: lastMsg != null ? _formatTimestamp(lastMsg.timestamp) : "",
      unreadCount: _getUnreadCountForUser(match.userId), // Implement based on your logic
    );
  }).toList();
});

// Helper functions (you'll need to implement these based on your chat message storage)
ChatMessage? _getLastMessageForUser(int userId, List<ChatMessage> messages) {
  // Find the most recent message with this user
  final userMessages = messages.where((msg) =>
  msg!.senderId == userId || msg.receiverId == userId
  ).toList();

  if (userMessages.isEmpty) return null;

  // Sort by timestamp and get the latest
  userMessages.sort((a, b) => b!.timestamp.compareTo(a!.timestamp));
  return userMessages.first;
}

int _getUnreadCountForUser(int userId) {
  // Implement your unread count logic here
  // This could be based on message read status, stored preferences, etc.
  return 0; // Placeholder
}

String _formatTimestamp(DateTime timestamp) {
  final now = DateTime.now();
  final difference = now.difference(timestamp);

  if (difference.inDays == 0) {
    // Same day - show time
    return "${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}";
  } else if (difference.inDays == 1) {
    return "Yesterday";
  } else if (difference.inDays < 7) {
    return "${difference.inDays} days ago";
  } else {
    return "${timestamp.day}/${timestamp.month}/${timestamp.year}";
  }
}

class MessagesScreen extends ConsumerStatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends ConsumerState<MessagesScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(darkModeProvider);
    final matchesWithChat = ref.watch(matchesWithChatProvider);

    // Filter matches based on search query
    final filteredMatches = matchesWithChat.where((matchData) =>
        matchData.match.name.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Messages',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? DatingColors.white :  DatingColors.black,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: isDarkMode ? DatingColors.black :  DatingColors.white,
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (val) => setState(() => searchQuery = val),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: DatingColors.middlegrey),
                hintText: 'Search matches...',
                hintStyle: TextStyle(color: DatingColors.middlegrey),
              filled: true,
                fillColor: isDarkMode ? DatingColors.black : DatingColors.lightgrey,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: DatingColors.middlegrey, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide:  BorderSide(color: DatingColors.darkGreen, width: 2),
                ),
              ),
            ),
          ),

          // Messages list
          Expanded(
            child: Container(
              color: isDarkMode ? DatingColors.black : DatingColors.white,
              child: filteredMatches.isEmpty
                  ?  Center(
                child: Text(
                  "No matched users",
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? DatingColors.white : DatingColors.middlegrey,
                  ),
                ),
              )
                  : ListView.separated(
                itemCount: filteredMatches.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: isDarkMode? DatingColors.white : DatingColors.lightgrey,
                  indent: 72, // Start after avatar
                ),
                itemBuilder: (context, index) {
                  final matchData = filteredMatches[index];
                  final match = matchData.match;

                  return InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          matchId: match.matchId,
                          userId: match.userId,
                          userName: match.name,
                          avatar: match.avatar,
                        ),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          // User avatar
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: DatingColors.surfaceGrey,
                            backgroundImage: NetworkImage(match.avatar),
                            onBackgroundImageError: (_, __) {},
                            child: match.avatar.isEmpty
                                ? Icon(Icons.person, color: DatingColors.middlegrey)
                                : null,
                          ),

                          const SizedBox(width: 16),

                          // Message content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // User name
                                Text(
                                  match.name,
                                  style:  TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isDarkMode ? DatingColors.white : DatingColors.black,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                // Last message
                                Text(
                                  matchData.lastMessage ?? "Tap to start chatting",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDarkMode? DatingColors.white : DatingColors.middlegrey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),

                          // Timestamp and unread count
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Timestamp
                              Text(
                                matchData.lastTimestamp ?? "",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDarkMode? DatingColors.white : DatingColors.middlegrey,
                                ),
                              ),

                              // Unread count badge
                              if (matchData.unreadCount > 0) ...[
                                const SizedBox(height: 8),
                                Container(
                                  width: 20,
                                  height: 20,
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                  decoration: BoxDecoration(
                                    color:  DatingColors.darkGreen,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    matchData.unreadCount > 99
                                        ? "99+"
                                        : matchData.unreadCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
