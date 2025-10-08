// import 'package:dating/constants/dating_app_user.dart';
// import 'package:flutter/material.dart';
// import '../screens/main_Screens/chatScreen.dart';

// class GlitchScreen extends StatelessWidget {
//   const GlitchScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: const Drawer(), // Dummy drawer icon on top left
//       appBar: AppBar(
//         backgroundColor: DatingColors.white,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: DatingColors.black),
//         title: const Text(
//           'Ever Qpid',
//           style: TextStyle(color: DatingColors.black),
//         ),
//         centerTitle: true,
//       ),
//       backgroundColor: DatingColors.white,
//       body: Stack(
//         children: [
//           // Top left circle
//           Positioned(
//             top: 10,
//             left: -90,
//             child: Container(
//               width: 150,
//               height: 150,
//               decoration: const BoxDecoration(
//                 color: DatingColors.lightGreen,
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),
//           // Top right circle
//           Positioned(
//             top: 60,
//             right: -80,
//             child: Container(
//               width: 200,
//               height: 200,
//               decoration: const BoxDecoration(
//                 color: DatingColors.lightGreen,
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),
//           // Refresh icon in circle
//           Positioned(
//             top: 120,
//             right: 40,
//             child: Container(
//               width: 80,
//               height: 80,
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: LinearGradient(
//                   colors: [
//                     DatingColors.primaryGreen,
//                     DatingColors.black,
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//               child: const Icon(Icons.refresh, color: DatingColors.white, size: 50),
//             ),
//           ),

//           // Main content
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24.0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text(
//                     "There’s Been A Little Glitch",
//                     textAlign: TextAlign.start,
//                     style: TextStyle(
//                       fontSize: 25,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     "Things Should Be Up And\nRunning Again In Just A Moment.\nPlease Try Restarting The App To\nMove Things Along.",
//                     textAlign: TextAlign.start,
//                     style: TextStyle(
//                       fontSize: 18,
//                       height: 1.5,
//                       color: DatingColors.black,
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (context) => ChatScreen()),
//                       );
//                     },
//                     child: const CircleAvatar(
//                       radius: 24,
//                       backgroundColor: Color.fromARGB(255, 19, 93, 22),
//                       child: Icon(Icons.arrow_forward, color: DatingColors.white),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
