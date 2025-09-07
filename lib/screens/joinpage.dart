// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:dating/screens/Entryselection_page.dart';
// // import '../screens/onboarding_screens.dart';

// // class JoinPageScreen extends ConsumerWidget {
// //   const JoinPageScreen({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     return Scaffold(
// //       body: Container(
// //         decoration: const BoxDecoration(
// //           gradient: LinearGradient(
// //             // colors: [Color(0xFF00A878), Color(0xFF028090)],
// //             colors: [Color(0xFF869E23), Color(0xFF000000)],
// //             begin: Alignment.topLeft,
// //             end: Alignment.bottomRight,
// //           ),
// //         ),
// //         child: Stack(
// //           children: [
// //             // Floating Images
// //             Positioned.fill(
// //               child: Padding(
// //                 padding: const EdgeInsets.only(top: 20),
// //                 child: Stack(
// //                   children: [
// //                     // First Column (2 images, partially out on top)
// //                     _profileImage("assets/Rectangle_47.png", -20, -10, 100, 150),
// //                     _profileImage("assets/Rectangle_44.png", 120, -10, 80, 150),

// //                     // Second Column (3 images)
// //                     _profileImage("assets/Rectangle_49.png", -90, 90, 100, 250),
// //                     _profileImage("assets/Rectangle_43.png", 80, 90, 90, 170),
// //                     _profileImage("assets/Rectangle_50.png", 240, 90, 90, 170),

// //                     // Third Column (1 image)
// //                     _profileImage("assets/Rectangle_51.png", 100, 200, 70, 200),

// //                     // Fourth Column (3 images, last partially out on bottom)
// //                     _profileImage("assets/Rectangle_54.png", -10, 295, 70, 160),
// //                     _profileImage("assets/Rectangle_52.png", 120, 295, 70, 190),
// //                     _profileImage("assets/Rectangle_53.png", 300, 295, 90, 150),

// //                     // Heart Symbol
// //                     Positioned(
// //                       top: 30,
// //                       right: 100,
// //                       child: Image.asset('assets/Vector.png')
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),

// //             // Main Content
// //             Align(
// //               alignment: Alignment.bottomLeft,
// //               child: Padding(
// //                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
// //                 child: Column(
// //                   mainAxisSize: MainAxisSize.min, // Ensures no extra space
// //                   crossAxisAlignment: CrossAxisAlignment.start, // Aligns text to the left
// //                   children: [
// //                     // Title
// //                     const Text(
// //                       "Find your\npartner in life",
// //                       textAlign: TextAlign.left,
// //                       style: TextStyle(
// //                         fontSize: 25,
// //                         fontWeight: FontWeight.bold,
// //                         color: Colors.white,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 10),

// //                     // Subtitle
// //                     const Text(
// //                       "We created to bring together amazing\n"
// //                       "singles who want to find love, laughter,\n"
// //                       "and happily ever after!",
// //                       textAlign: TextAlign.left,
// //                       style: TextStyle(
// //                         fontSize: 14,
// //                         color: Colors.white70,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 15),

// //                     // Join Now Button
// //                     SizedBox(
// //                       width: double.infinity, // Button takes full width
// //                       height: 60, // Proper button height
// //                       child: ElevatedButton(
// //                         onPressed: () {
// //                           Navigator.push(
// //                             context,
// //                             MaterialPageRoute(builder: (context) => SelectPage()),
// //                             //  MaterialPageRoute(builder: (context) => OnboardingScreen()),
// //                           );
// //                         },
// //                         style: ElevatedButton.styleFrom(
// //                           backgroundColor:  Color(0xffE9F1C4),
// //                           shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(15),
                            
// //                           ),
// //                         ),
// //                         child: const Text(
// //                           "Join now",
// //                           style: TextStyle(
// //                             fontSize: 20,
// //                             fontWeight: FontWeight.bold,
// //                             color: Colors.green,
// //                             // backgroundColor:  Color(0xffE9F1C4),
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // Profile Image Widget with Positioned and Border
// //   Widget _profileImage(String imageUrl, double top, double left, double width, double height) {
// //     return Positioned(
// //       top: top,
// //       left: left,
// //       child: Container(
// //         width: width,
// //         height: height,
// //         decoration: BoxDecoration(
// //           // border: Border.all(color: Colors.white, width: 1),
// //           // borderRadius: BorderRadius.circular(16),
// //           // boxShadow: [
// //           //   BoxShadow(
// //           //     color: Colors.black.withOpacity(0.2),
// //           //     blurRadius: 2,
// //           //     // spreadRadius: 2,
// //           //     offset: Offset(2, 2),
// //           //   ),
// //           // ],
// //         ),
// //         child: ClipRRect(
// //           borderRadius: BorderRadius.circular(14),
// //           child: Image.asset(
// //             imageUrl,
// //             fit: BoxFit.cover,
// //              width: 300,     // Set your desired width
// //              height: 250,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:dating/constants/dating_app_user.dart';
// import 'package:dating/screens/tab_bar/tabScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:dating/screens/Entryselection_page.dart';

// class JoinPageScreen extends ConsumerWidget {
//   const JoinPageScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final size = MediaQuery.of(context).size;
//     final height = size.height;
//     final width = size.width;

//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [DatingColors.darkGreen, DatingColors.brown],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Stack(
//           children: [
//             // Floating Images
//             Positioned.fill(
//               child: Padding(
//                 padding: EdgeInsets.only(top: height * 0.02),
//                 child: Stack(
//                   children: [
//                     _profileImage("assets/Rectangle_47.png", -20, -10, 100, 150),
//                     _profileImage("assets/Rectangle_44.png", 120, -10, 80, 150),
//                     _profileImage("assets/Rectangle_49.png", -90, 90, 100, 250),
//                     _profileImage("assets/Rectangle_43.png", 80, 90, 90, 170),
//                     _profileImage("assets/Rectangle_50.png", 240, 90, 90, 170),
//                     _profileImage("assets/Rectangle_51.png", 100, 200, 70, 200),
//                     _profileImage("assets/Rectangle_54.png", -10, 295, 70, 160),
//                     _profileImage("assets/Rectangle_52.png", 120, 295, 70, 190),
//                     _profileImage("assets/Rectangle_53.png", 300, 295, 90, 150),
//                     Positioned(
//                       top: 30,
//                       right: 100,
//                       child: Image.asset('assets/Vector.png'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Main Content
//             Align(
//               alignment: Alignment.bottomLeft,
//               child: Padding(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: width * 0.05, vertical: height * 0.05),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Find your\npartner in life",
//                       textAlign: TextAlign.left,
//                       style: TextStyle(
//                         fontSize: height * 0.03,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     SizedBox(height: height * 0.01),
//                     Text(
//                       "We created to bring together amazing\n"
//                       "singles who want to find love, laughter,\n"
//                       "and happily ever after!",
//                       textAlign: TextAlign.left,
//                       style: TextStyle(
//                         fontSize: height * 0.018,
//                         color: Colors.white70,
//                       ),
//                     ),
//                     SizedBox(height: height * 0.025),
//                     SizedBox(
//                       width: double.infinity,
//                       height: height * 0.07, // Responsive button height
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => SelectPage()),
//                           );
//                           // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SubscriptionTabScreen()));
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xffE9F1C4),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                         ),
//                         child: Text(
//                           "Join now",
//                           style: TextStyle(
//                             fontSize: height * 0.022,
//                             fontWeight: FontWeight.bold,
//                             color:DatingColors.darkGreen,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _profileImage(
//       String imageUrl, double top, double left, double width, double height) {
//     return Positioned(
//       top: top,
//       left: left,
//       child: Container(
//         width: width,
//         height: height,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(14),
//           child: Image.asset(
//             imageUrl,
//             fit: BoxFit.cover,
//             width: width,
//             height: height,
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/screens/Entryselection_page.dart';
// import 'package:dating/screens/signupprocess/Entryselection_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JoinPageScreen extends ConsumerStatefulWidget {
  const JoinPageScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<JoinPageScreen> createState() => _JoinPageScreenState();
}

class _JoinPageScreenState extends ConsumerState<JoinPageScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SelectPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Fullscreen background image
          Positioned.fill(
            child: Image.asset(
              "assets/everqpidbg.png",
              fit: BoxFit.cover,
            ),
          ),

          // Center column with logo + text
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Small overlay image (logo)
                Image.asset(
                  "assets/everlogo.png",
                  width: size.width * 0.4,
                  height: size.width * 0.4,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 4),

                // Text below logo
                const Text(
                  "Looking for your Qpid",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: DatingColors.qpidColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
