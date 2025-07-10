// import 'package:flutter/material.dart';
// import '../tab_bar/boost_screen.dart';
// import 'spotlight.dart';
// import '../tab_bar/premium.dart';
// import '../tab_bar/premiumPlus.dart';

// import 'package:flutter/material.dart';

// class SubscriptionTabScreen extends StatelessWidget {
//   const SubscriptionTabScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 4,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           title: const Text(
//             'Subscription',
//             style: TextStyle(color: Colors.black),
//           ),
//           centerTitle: true,
//           bottom: const TabBar(
//             isScrollable: true,
//             labelColor: Colors.black,
//             unselectedLabelColor: Colors.grey,
//             indicatorColor: Colors.black,
//             tabs: [
//               Tab(text: "Boost"),
//               Tab(text: "Premium"),
//               Tab(text: "Premium+"),
              
//             ],
//           ),
//         ),
//         body: const TabBarView(
//           children: [
//             BoostTab(),
//             PremiumTab(),
//             PremiumPlusTab(),
           
//           ],
//         ),
//       ),
//     );
//   }
// }
