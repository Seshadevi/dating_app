// // ✅ CHAT UI (chat_screen.dart)
// import 'package:dating/provider/chat_socket_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:dating/provider/chat_provider.dart';

// class MessagesScreen extends ConsumerStatefulWidget {
//   final int matchedUserId;
//   final String matchedUserName;

//   const MessagesScreen({super.key, required this.matchedUserId, required this.matchedUserName});

//   @override
//   ConsumerState<MessagesScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends ConsumerState<MessagesScreen> {
//   final TextEditingController _controller = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(chatProvider.notifier).openChat(widget.matchedUserId);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final messages = ref.watch(chatProvider);

//     return Scaffold(
//       appBar: AppBar(title: Text(widget.matchedUserName)),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 final msg = messages[index];
//                 final isMe = msg.senderId != widget.matchedUserId;
//                 return Align(
//                   alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: EdgeInsets.all(8),
//                     padding: EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: isMe ? Colors.green[100] : Colors.grey[200],
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(msg.message),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: _controller,
//                   decoration: InputDecoration(
//                     hintText: "Type a message...",
//                     contentPadding: EdgeInsets.all(12),
//                   ),
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(Icons.send),
//                 onPressed: () {
//                   if (_controller.text.trim().isNotEmpty) {
//                     ref.read(chatProvider.notifier).sendMessage(
//                       widget.matchedUserId,
//                       _controller.text.trim(),
//                     );
//                     _controller.clear();
//                   }
//                 },
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }










// // ✅ Modify MessagesScreen to use provider:
// import 'package:dating/provider/chat_socket_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class MessagesScreen extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final messages = ref.watch(chatListProvider);

//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: Text('Messages'),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 1,
//       ),
//       body: messages.isEmpty
//           ? Center(child: Text("No messages yet."))
//           : ListView.builder(
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 return MessageTile(message: messages[index]);
//               },
//             ),
//     );
//   }
// }

// class MessageTile extends StatelessWidget {
//   final MessageData message;

//   const MessageTile({Key? key, required this.message}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () => print("Tapped on \${message.name}"),
//       child: Container(
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
//         ),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 25,
//               backgroundImage: NetworkImage(message.avatar),
//             ),
//             SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(message.name, style: TextStyle(fontWeight: FontWeight.bold)),
//                   SizedBox(height: 4),
//                   Text(message.message, maxLines: 1, overflow: TextOverflow.ellipsis),
//                 ],
//               ),
//             ),
//             Column(
//               children: [
//                 Text(message.timestamp, style: TextStyle(fontSize: 12)),
//                 if (message.unreadCount > 0)
//                   Container(
//                     margin: EdgeInsets.only(top: 8),
//                     padding: EdgeInsets.all(6),
//                     decoration: BoxDecoration(
//                       color: Colors.red,
//                       shape: BoxShape.circle,
//                     ),
//                     child: Text(
//                       message.unreadCount.toString(),
//                       style: TextStyle(color: Colors.white, fontSize: 12),
//                     ),
//                   )
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MessageData {
//   final String name;
//   final String message;
//   final String timestamp;
//   final String avatar;
//   final int unreadCount;

//   MessageData({
//     required this.name,
//     required this.message,
//     required this.timestamp,
//     required this.avatar,
//     required this.unreadCount,
//   });
// }





















import 'package:dating/screens/profile_screens/profile_bottomNavigationbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class MessagesScreen extends StatelessWidget {
  final List<MessageData> messages = [
    MessageData(
      name: 'Cameron Williamson',
      message: 'we have visit your site today',
      timestamp: '2 min ago',
      avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
      unreadCount: 2,
    ),
    MessageData(
      name: 'Dianne Russell',
      message: 'see you buddy',
      timestamp: '15 min ago',
      avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      unreadCount: 1,
    ),
    MessageData(
      name: 'Clara Due',
      message: 'should i have wanted warrier',
      timestamp: '1 hours ago',
      avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
      unreadCount: 0,
    ),
    MessageData(
      name: 'Robert Fox',
      message: 'ok got it',
      timestamp: '4 days ago',
      avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
      unreadCount: 0,
    ),
    MessageData(
      name: 'Daniel Rao',
      message: 'wanna go outside somebody?',
      timestamp: '6 days ago',
      avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
      unreadCount: 0,
    ),
    MessageData(
      name: 'Clara Due',
      message: 'should i have wanted warrier',
      timestamp: '1 hours ago',
      avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
      unreadCount: 0,
    ),
     MessageData(
      name: 'Robert Fox',
      message: 'ok got it',
      timestamp: '4 days ago',
      avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
      unreadCount: 0,
    ),
    MessageData(
      name: 'Daniel Rao',
      message: 'wanna go outside somebody?',
      timestamp: '6 days ago',
      avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
      unreadCount: 0,
    ),
    MessageData(
      name: 'Clara Due',
      message: 'should i have wanted warrier',
      timestamp: '1 hours ago',
      avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
      unreadCount: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 1,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              children: [
                // // Custom Status Bar
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Row(
                //         children: [
                //           // Signal bars
                //           Row(
                //             children: List.generate(4, (index) {
                //               return Container(
                //                 margin: EdgeInsets.only(right: 2),
                //                 width: 3,
                //                 height: 4.0 + (index * 2),
                //                 decoration: BoxDecoration(
                //                   color: Colors.black87,
                //                   borderRadius: BorderRadius.circular(1),
                //                 ),
                //               );
                //             }),
                //           ),
                //           SizedBox(width: 8),
                //           Icon(Icons.wifi, size: 16),
                //         ],
                //       ),
                //       Text(
                //         '12:30',
                //         style: TextStyle(
                //           fontSize: 14,
                //           fontWeight: FontWeight.w500,
                //         ),
                //       ),
                //       Icon(Icons.battery_full, size: 20),
                //     ],
                //   ),
                // ),
                // Header with back button and title
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      // GestureDetector(
                      //   onTap: () => Navigator.pop(context),
                        // child: Icon(
                        //   Icons.arrow_back_ios,
                        //   size: 20,
                        //   color: Colors.black87,
                        // ),
                      // ),
                      SizedBox(width: 16),
                      Text(
                        'Messages',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                 color: Color(0xFFE9F1C4), // Background color
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.green, // 🔶 Change this to any color you want
                    width: 1,             // Optional: adjust border width
                  ),
              ),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.grey[700]),
                  hintText: 'search',
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          // Messages List
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return MessageTile(message: messages[index]);
                },
              ),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 4,),
    );
  }
}

class MessageTile extends StatelessWidget {
  final MessageData message;

  const MessageTile({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle message tap
        print('Tapped on ${message.name}');
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[100]!,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey[300],
              backgroundImage: NetworkImage(message.avatar),
            ),
            SizedBox(width: 16),
            // Message Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    message.message,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Timestamp and Badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  message.timestamp,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                if (message.unreadCount > 0) ...[
                  SizedBox(height: 8),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Color(0xFFFF4757),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        message.unreadCount.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
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
  }
}

class MessageData {
  final String name;
  final String message;
  final String timestamp;
  final String avatar;
  final int unreadCount;

  MessageData({
    required this.name,
    required this.message,
    required this.timestamp,
    required this.avatar,
    required this.unreadCount,
  });
}