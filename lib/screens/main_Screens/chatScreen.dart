// import 'package:dating/screens/profile_screens/profile_screen.dart';
// import 'package:dating/screens/tab_bar/tabbartotal.dart';
// import 'package:flutter/material.dart';
// import '../main_Screens/bottomnavigationbar.dart';
// import '../tab_bar/tabScreen.dart';

// class ChatScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           "Chat",
//           style: TextStyle(color: Colors.black),
//         ),
//         centerTitle: true,
//         leading: Icon(Icons.arrow_back, color: Colors.black),
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Stack(
//         children: [
//         Column(
//           children: [
            
//                 // const SizedBox(height: 20),
//                 // Replace with your actual image asset or widget
//                 Positioned(
//                   left: 10,
//                   child: Container(
//                     height: 300,
//                     decoration: const BoxDecoration(
//                       image: DecorationImage(
//                         image: AssetImage('assets/home_image.png'),
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                   ),
//                 ),
                
//                 const SizedBox(height: 30),
//                 const Text(
//                   "Connections Start Here",
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 12),
//                 const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 24.0),
//                   child: Text(
//                     "When You Both Swipe Right On Each Other, You’ll Match. Here’s Where You Can Chat.",
//                     style: TextStyle(fontSize: 14, color: Colors.black87),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 Padding(
//   padding: const EdgeInsets.symmetric(horizontal: 24.0),
//   child: Material(
//     borderRadius: BorderRadius.circular(12),
//     child: InkWell(
//       onTap: () {
//         // Add your button action here
//         // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SubscriptionTabScreen(typeId: ,)));
//         //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
//         print("Find Your Person tapped");
//       },
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         width: double.infinity,
//         height: 50,
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [Color(0xFFB0E300), Colors.black],
//           ),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: const Center(
//           child: Text(
//             "Find Your Person",
//             style: TextStyle(color: Colors.white, fontSize: 16),
//           ),
//         ),
//       ),
//     ),
//   ),
// ),

//                 const SizedBox(height: 12),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                   child: Container(
//                     width: double.infinity,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       color: Color(0xFFF1F4D4),
//                       border: Border.all(color: Colors.black),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Center(
//                       child: Text(
//                         "Try A Spotlight",
//                         style: TextStyle(color: Colors.black, fontSize: 16),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
      
     
//       bottomNavigationBar: BottomNavBar(),
//     );
//   }
// }
