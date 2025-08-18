import 'package:flutter/material.dart';
// Import your actual screens here
import 'package:flutter/services.dart'; 
import 'package:dating/screens/profile_screens/message_screen.dart';
import 'package:dating/screens/profile_screens/discover_screen.dart';
import 'package:dating/screens/profile_screens/heartsync_screen.dart';
import 'package:dating/screens/profile_screens/liked_Screen.dart';
import 'package:dating/screens/profile_screens/profile_screen.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState
    extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;
  DateTime? _lastBackPressed;

  final List<Widget> _pages = [
        ProfileScreen(),
        DiscoverScreen(),
        MyHeartsyncPage(),
        LikedYouScreen(),
        MessagesScreen(),
  ];
  
  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final now = DateTime.now();
        if (_lastBackPressed == null ||
            now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
          _lastBackPressed = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tap again to exit app'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          // Exit the app
          await SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, 'assets/Profile-.png', 50, 55),
              _buildNavItem(1, 'assets/good_logo.png', 40, 50),
              _buildNavItem(2, 'assets/peoples-.png', 50, 55),
              _buildNavItem(3, 'assets/Heart@3x.png', 40, 50),
              _buildNavItem(4, 'assets/chatnav.png', 40, 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String assetPath, double width, double height) {
    final isSelected = index == _selectedIndex;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: SizedBox(
        width: 60,
        height: 60,
        child: Center(
          child: Image.asset(
            assetPath,
            width: width,
            height: height,
            fit: BoxFit.contain,
            color: isSelected ? const Color.fromARGB(255, 91, 110, 4) : null,
          ),
        ),
      ),
    );
  }
}












// import 'package:dating/screens/profile_screens/chat_pay_Screen.dart';
// import 'package:dating/screens/profile_screens/discover_screen.dart';
// import 'package:dating/screens/profile_screens/heartsync_screen.dart';
// import 'package:dating/screens/profile_screens/liked_Screen.dart';
// import 'package:dating/screens/profile_screens/profile_screen.dart';
// import 'package:flutter/material.dart';


// class CustomBottomNavigationBar extends StatefulWidget {
//   const CustomBottomNavigationBar({super.key});

//   @override
//   State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
// }

// class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = [
//     ProfileScreen(),
//     DiscoverScreen(),
//     MyHeartsyncPage(),
//     LikedYouScreen(),
//     MessagesScreen(),
//   ];

//   void _onItemTapped(int index) {
//     if (index == _selectedIndex) return;
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: _selectedIndex,
//         children: _pages,
//       ),
//       bottomNavigationBar: Container(
//         height: 60,
//         padding: const EdgeInsets.symmetric(horizontal: 8),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             _buildNavItem(0, 'assets/Profile-.png', 40, 50),
//             _buildNavItem(1, 'assets/good_logo.png', 40, 50),
//             _buildNavItem(2, 'assets/peoples-.png', 40, 50),
//             _buildNavItem(3, 'assets/Heart@3x.png', 40, 50),
//             _buildNavItem(4, 'assets/chatnav.png', 40, 50),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNavItem(int index, String assetPath, double width, double height) {
//     final isSelected = index == _selectedIndex;

//     return GestureDetector(
//       onTap: () => _onItemTapped(index),
//       child: SizedBox(
//         width: 60,
//         height: 60,
//         child: Center(
//           child: Image.asset(
//             assetPath,
//             width: width,
//             height: height,
//             fit: BoxFit.contain,
//             color: isSelected ? const Color.fromARGB(255, 91, 110, 4) : null,
//           ),
//         ),
//       ),
//     );
//   }
// }











// import 'package:flutter/material.dart';

// class CustomBottomNavigationBar extends StatelessWidget {
//   final int currentIndex;

//   const CustomBottomNavigationBar({Key? key, required this.currentIndex})
//       : super(key: key);

//   void _onTabTapped(BuildContext context, int index) {
//     if (index == currentIndex) return;

//     switch (index) {
//       case 0:
//         Navigator.pushReplacementNamed(context, 'profilescreen');
//         break;
//       case 1:
//         Navigator.pushReplacementNamed(context, 'discoverscreen');
//         break;
//       case 2:
//         Navigator.pushReplacementNamed(context, 'myheartsyncpage');
//         break;
//       case 3:
//         Navigator.pushReplacementNamed(context, 'likedyouscreen');
//         break;
//       case 4:
//         Navigator.pushReplacementNamed(context, 'messagescreen');
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 60,
//       padding: const EdgeInsets.symmetric(horizontal: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(color: Colors.black12, blurRadius: 8),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildNavItem(context, 0, 'assets/Profile-.png', 40, 50),
//           _buildNavItem(context, 1, 'assets/good_logo.png', 40, 50),
//           _buildNavItem(context, 2, 'assets/peoples-.png', 40, 50),
//           _buildNavItem(context, 3, 'assets/Heart@3x.png', 40, 50),
//           _buildNavItem(context, 4, 'assets/chatnav.png', 40, 50),
//         ],
//       ),
//     );
//   }

//   Widget _buildNavItem(
//     BuildContext context,
//     int index,
//     String assetPath,
//     double width,
//     double height,
//   ) {
//     final isSelected = index == currentIndex;

//     return GestureDetector(
//       onTap: () => _onTabTapped(context, index),
//       child: SizedBox(
//         width: 60,
//         height: 60,
//         child: Center(
//           child: Image.asset(
//             assetPath,
//             width: width,
//             height: height,
//             fit: BoxFit.contain,
//             color: isSelected ? const Color.fromARGB(255, 91, 110, 4) : null,
//           ),
//         ),
//       ),
//     );
//   }
// }
