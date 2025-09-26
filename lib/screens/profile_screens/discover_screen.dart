// import 'package:dating/constants/dating_app_user.dart';
// import 'package:dating/provider/loginProvider.dart';
// import 'package:dating/provider/socket_heartsync_provider';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
//
// import '../../provider/socket_heartsync_provider.dart'; // for parsing dob
//
// class DiscoverScreen extends ConsumerWidget {
//   const DiscoverScreen({super.key});
//
//   // 🔹 Convert dob string ("06/09/2007") → Age in years
//   int _calculateAge(String? dobString) {
//     if (dobString == null || dobString.isEmpty) return 0;
//     try {
//       final dob = DateFormat("dd/MM/yyyy").parse(dobString);
//       final now = DateTime.now();
//       int age = now.year - dob.year;
//       if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
//         age--;
//       }
//       return age;
//     } catch (_) {
//       return 0;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final users = ref.watch(socketUserProvider);
//
//     // 🔹 Current logged in user
//     final myUser = ref.watch(loginProvider);
//
//
//  // ✅ Extract my interests
// final myInterests = myUser?.data?.first.user?.interests
//         ?.map((i) => i.interests ?? "")
//         .where((i) => i.isNotEmpty)
//         .toList()
//     ?? [];
//
// // ✅ Extract my goals (lookingFor)
// final myGoals = myUser?.data?.first.user?.lookingFor
//         ?.map((g) => g.value ?? "")
//         .where((g) => g.isNotEmpty)
//         .toList()
//     ?? [];
//
//
//     // 🔹 Filter: similar interests
//     final similarInterestUsers = users.where((u) {
//       final userInterests = (u['interests'] as List?)
//               ?.map((i) => i['interests'].toString())
//               .toList() ??
//           [];
//       return userInterests.any((i) => myInterests.contains(i));
//     }).toList();
//
//     // 🔹 Filter: same goals
//     final sameGoalUsers = users.where((u) {
//       final userGoals = (u['lookingFor'] as List?)
//               ?.map((g) => g['value'].toString())
//               .toList() ??
//           [];
//       return userGoals.any((g) => myGoals.contains(g));
//     }).toList();
//
//     return Scaffold(
//       backgroundColor: DatingColors.white,
//       appBar: AppBar(
//         backgroundColor: DatingColors.white,
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         title: const Text(
//           "Discover",
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//             fontSize: 22,
//           ),
//         ),
//         actions: const [
//           Padding(
//             padding: EdgeInsets.only(right: 12),
//             child: Icon(Icons.info_outline, color: DatingColors.everqpidColor),
//           )
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 20),
//             Center(
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: DatingColors.everqpidColor,
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: const Text(
//                   "See New People in 17 Hours",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               "Discover New Genuine Humans With People\nWho Match Your Vibes, Refreshed Every Day.",
//               textAlign: TextAlign.center,
//               style: TextStyle(color: DatingColors.everqpidColor, fontSize: 12),
//             ),
//             const SizedBox(height: 30),
//             const Text(
//               "Recommended For You",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//
//             if (users.isNotEmpty) _bigProfileCard(users.first) else _noDataCard(),
//
//             const SizedBox(height: 40),
//
//             // Buttons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _gradientCircleButton(Icons.thumb_down_alt_outlined, DatingColors.white),
//                 _gradientCircleButton(Icons.star_border_outlined, DatingColors.white),
//                 _gradientCircleButton(Icons.thumb_up_alt_outlined, DatingColors.white),
//               ],
//             ),
//             const SizedBox(height: 50),
//             Center(
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: DatingColors.everqpidColor,
//                   borderRadius: BorderRadius.circular(1),
//                 ),
//                 child: const Text(
//                   "Based On Your Profile And Past Matches",
//                   style: TextStyle(fontSize: 13),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 30),
//
//             // ✅ Similar Interests
//             const Text("similar interests",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
//             const SizedBox(height: 20),
//             _horizontalCardList(similarInterestUsers, "interest"),
//
//             const SizedBox(height: 24),
//
//             // ✅ Same Goals
//             const Text("same dating goals",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
//             const SizedBox(height: 20),
//             _horizontalCardList(sameGoalUsers, "goal"),
//
//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // 🔹 Big top profile card
//   Widget _bigProfileCard(Map<String, dynamic> user) {
//     final hasImage = user['profile_pics'] != null && user['profile_pics'].isNotEmpty;
//     final imgUrl = hasImage ? "http://97.74.93.26:6100${user['profile_pics'][0]['url']}" : null;
//     final age = _calculateAge(user['dob']);
//
//     return Stack(
//       children: [
//         ClipRRect(
//           borderRadius: BorderRadius.circular(10),
//           child: hasImage
//               ? Image.network(
//                   imgUrl!,
//                   height: 420,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 )
//               : Container(
//                   height: 420,
//                   width: double.infinity,
//                   color: DatingColors.lightgrey.withOpacity(0.3),
//                   child: const Icon(Icons.person, size: 120, color: Colors.grey),
//                 ),
//         ),
//         Positioned(
//           left: 16,
//           bottom: 20,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "${user['firstName'] ?? ''}${age > 0 ? ', $age' : ''}",
//                 style: const TextStyle(
//                   fontSize: 22,
//                   color: DatingColors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               const Text("🟢 Active now",
//                   style: TextStyle(color: DatingColors.lightgrey)),
//             ],
//           ),
//         )
//       ],
//     );
//   }
//
//   Widget _noDataCard() {
//     return Container(
//       height: 420,
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: DatingColors.lightgrey.withOpacity(0.2),
//       ),
//       child: const Text("No users available yet"),
//     );
//   }
//
//   Widget _gradientCircleButton(IconData icon, Color iconColor) {
//     return Container(
//       width: 64,
//       height: 64,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         gradient: const LinearGradient(
//           colors: [DatingColors.primaryGreen, DatingColors.everqpidColor],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         boxShadow: const [
//           BoxShadow(color: DatingColors.everqpidColor, blurRadius: 4, offset: Offset(2, 2))
//         ],
//       ),
//       child: Icon(icon, color: iconColor, size: 28),
//     );
//   }
//
//   // 🔹 Horizontal scroll list
//   Widget _horizontalCardList(List<Map<String, dynamic>> profiles, String type) {
//     if (profiles.isEmpty) {
//       return const Center(child: Text("No users found"));
//     }
//
//     return SizedBox(
//       height: 270,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         itemCount: profiles.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 18),
//         itemBuilder: (context, index) {
//           final user = profiles[index];
//           final hasImage = user['profile_pics'] != null && user['profile_pics'].isNotEmpty;
//           final imgUrl = hasImage ? "http://97.74.93.26:6100${user['profile_pics'][0]['url']}" : null;
//           final age = _calculateAge(user['dob']);
//
//           List<String> tags = [];
//           if (type == "interest" && user['interests'] != null) {
//             tags = (user['interests'] as List)
//                 .map<String>((i) => i['interests'].toString())
//                 .toList();
//           } else if (type == "goal" && user['lookingFor'] != null) {
//             tags = (user['lookingFor'] as List)
//                 .map<String>((g) => g['value'].toString())
//                 .toList();
//           }
//
//           return Container(
//             width: 160,
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [DatingColors.middlepink, DatingColors.everqpidColor],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: DatingColors.primaryGreen, width: 1.2),
//               boxShadow: [
//                 BoxShadow(
//                   color: DatingColors.everqpidColor.withOpacity(0.1),
//                   blurRadius: 6,
//                   offset: const Offset(2, 4),
//                 ),
//               ],
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(10),
//               child: Column(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: hasImage
//                         ? Image.network(
//                             imgUrl!,
//                             height: 120,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                           )
//                         : Container(
//                             height: 120,
//                             width: double.infinity,
//                             color: DatingColors.lightgrey.withOpacity(0.3),
//                             child: const Icon(Icons.person,
//                                 size: 60, color: Colors.grey),
//                           ),
//                   ),
//                   const SizedBox(height: 8),
//                   Wrap(
//                     spacing: 6,
//                     runSpacing: -6,
//                     children: tags.map((t) {
//                       return Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: DatingColors.primaryGreen,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           t,
//                           style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     "${user['firstName'] ?? ''}${age > 0 ? ', $age' : ''}",
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
//
//
//
//
//
//
//
// // import 'package:dating/constants/dating_app_user.dart';
// // import 'package:dating/screens/profile_screens/profile_bottomNavigationbar.dart';
// // import 'package:flutter/material.dart';
//
// // class DiscoverScreen extends StatefulWidget {
// //   const DiscoverScreen({super.key});
//
// //   @override
// //   State<DiscoverScreen> createState() => _DiscoverScreenState();
// // }
//
// // class _DiscoverScreenState extends State<DiscoverScreen> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: DatingColors.white,
// //       appBar: AppBar(
// //         backgroundColor: DatingColors.white,
// //         elevation: 0,
// //         automaticallyImplyLeading: false,
// //         title: const Text(
// //           "Discover",
// //           style: TextStyle(
// //             color: Colors.black,
// //             fontWeight: FontWeight.bold,
// //             fontSize: 22,
// //           ),
// //         ),
// //         actions: const [
// //           Padding(
// //             padding: EdgeInsets.only(right: 12),
// //             child: Icon(Icons.info_outline, color: DatingColors.everqpidColor),
// //           )
// //         ],
// //       ),
//
//
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 12),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             const SizedBox(height: 20),
// //             Center(
// //               child: Container(
// //                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
// //                 decoration: BoxDecoration(
// //                   color: DatingColors.everqpidColor,
// //                   borderRadius: BorderRadius.circular(30),
// //                 ),
// //                 child: const Text(
// //                   "See New People in 17 Hours",
// //                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 20),
// //             const Text(
// //               "Discover New Genuine Humans With People\nWho Match Your Vibes, Refreshed Every Day.",
// //               textAlign: TextAlign.center,
// //               style: TextStyle(color: DatingColors.everqpidColor, fontSize: 12),
// //             ),
// //             const SizedBox(height: 30),
// //             const Text(
// //               "Recommended For You",
// //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 12),
//
// //             // Big Profile Card
// //             Stack(
// //               children: [
// //                 ClipRRect(
// //                   borderRadius: BorderRadius.circular(10),
// //                   child: Image.network(
// //                     "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg",
// //                     height: 420,
// //                     width: double.infinity,
// //                     fit: BoxFit.cover,
// //                   ),
// //                 ),
// //                 Positioned(
// //                   left: 16,
// //                   bottom: 20,
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: const [
// //                       Text(
// //                         "Kalvin, 23",
// //                         style: TextStyle(
// //                           fontSize: 22,
// //                           color: DatingColors.white,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                       SizedBox(height: 4),
// //                       Text(
// //                         " 0.8 km nearby",
// //                         style: TextStyle(color: DatingColors.white),
// //                       ),
// //                       Text(
// //                         "🟢 Active now",
// //                         style: TextStyle(color: DatingColors.lightgrey),
// //                       ),
// //                     ],
// //                   ),
// //                 )
// //               ],
// //             ),
//
// //             const SizedBox(height: 40),
//
// //             // Buttons: Dislike, Star, Like
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceAround,
// //               children: [
// //                 _gradientCircleButton(Icons.thumb_down_alt_outlined, DatingColors.white),
// //                 _gradientCircleButton(Icons.star_border_outlined, DatingColors.white),
// //                 _gradientCircleButton(Icons.thumb_up_alt_outlined, DatingColors.white),
// //               ],
// //             ),
// //             const SizedBox(height: 50),
// //             Center(
// //               child: Container(
// //                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
// //                 decoration: BoxDecoration(
// //                   color: DatingColors.everqpidColor,
// //                   borderRadius: BorderRadius.circular(1),
// //                 ),
// //                 child: const Text(
// //                   "Based On Your Profile And Past Matches",
// //                   style: TextStyle(fontSize: 13),
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 30),
//
// //             const Text(
// //               "similar interests",
// //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
// //             ),
// //             const SizedBox(height: 40),
// //             _horizontalCardList(),
//
// //             const SizedBox(height: 24),
// //             const Text(
// //               "same dating goals",
// //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
// //             ),
// //             const SizedBox(height: 12),
// //             _horizontalCardList(),
//
// //             const SizedBox(height: 30),
// //           ],
// //         ),
// //       ),
// //       // bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
// //     );
// //   }
//
// //   // Gradient Circle Button Widget
// //   Widget _gradientCircleButton(IconData icon, Color iconColor) {
// //     return Container(
// //       width: 64,
// //       height: 64,
// //       decoration: BoxDecoration(
// //         shape: BoxShape.circle,
// //         gradient: LinearGradient(
// //           colors: [DatingColors.primaryGreen, DatingColors.everqpidColor],
// //           begin: Alignment.topLeft,
// //           end: Alignment.bottomRight,
// //         ),
// //         boxShadow: const [
// //           BoxShadow(color: DatingColors.everqpidColor, blurRadius: 4, offset: Offset(2, 2))
// //         ],
// //       ),
// //       child: Icon(icon, color: iconColor, size: 28),
// //     );
// //   }
//
// //   // Horizontal Scroll Cards
// //  Widget _horizontalCardList() {
// //   final profiles = [
// //     {
// //       "name": "Meenu, 25",
// //       "tag": "☕ Coffee",
// //       "img": "https://randomuser.me/api/portraits/women/1.jpg"
// //     },
// //     {
// //       "name": "Deepa, 25",
// //       "tag": "🎯 Friendship",
// //       "img": "https://randomuser.me/api/portraits/women/2.jpg"
// //     },
// //   ];
//
// //   return SizedBox(
// //     height: 270,
// //     child: ListView.separated(
// //       scrollDirection: Axis.horizontal,
// //       padding: const EdgeInsets.symmetric(horizontal: 16),
// //       itemCount: profiles.length,
// //       separatorBuilder: (_, __) => const SizedBox(width: 18),
// //       itemBuilder: (context, index) {
// //         final user = profiles[index];
// // return Container(
// //   width: 140,
// //   decoration: BoxDecoration(
// //      gradient: LinearGradient(
// //           colors: [DatingColors.middlepink, DatingColors.everqpidColor],
// //           begin: Alignment.topLeft,
// //           end: Alignment.bottomRight,
// //         ),
// //     borderRadius: BorderRadius.circular(16),
// //     border: Border.all(color: DatingColors.primaryGreen, width: 1.2),
// //     boxShadow: [
// //       BoxShadow(
// //         color: DatingColors.everqpidColor.withOpacity(0.1),
// //         blurRadius: 6,
// //         offset: Offset(2, 4),
// //       ),
// //     ],
// //   ),
// //   child: Padding(
// //     padding: const EdgeInsets.all(10), // ✅ Padding on all 4 sides
// //     child: Column(
// //       crossAxisAlignment: CrossAxisAlignment.center,
// //       children: [
// //         ClipRRect(
// //           borderRadius: BorderRadius.circular(12),
// //           child: Image.network(
// //             user['img']!,
// //             height: 150,
// //             width: double.infinity,
// //             fit: BoxFit.cover,
// //             // alignment: Alignment.topCenter,
// //           ),
// //         ),
// //         const SizedBox(height: 10),
// //         Container(
// //           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
// //           decoration: BoxDecoration(
// //             color:DatingColors.primaryGreen,
// //             borderRadius: BorderRadius.circular(12),
// //           ),
// //           child: Text(
// //             user['tag']!,
// //             style: const TextStyle(
// //               fontSize: 12,
// //               fontWeight: FontWeight.w500,
// //               color: Colors.black,
// //             ),
// //           ),
// //         ),
// //         const SizedBox(height: 6),
// //         Text(
// //           user['name']!,
// //           style: const TextStyle(
// //             fontWeight: FontWeight.bold,
// //             fontSize: 14,
// //             color: Colors.black,
// //           ),
// //         ),
// //       ],
// //     ),
// //   ),
// // );
//
// //       },
// //     ),
// //   );
// // }
// // }
