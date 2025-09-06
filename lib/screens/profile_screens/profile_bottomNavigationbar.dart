// import 'package:dating/model/loginmodel.dart';
// import 'package:dating/provider/loginProvider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:dating/screens/profile_screens/message_screen.dart';
// import 'package:dating/screens/profile_screens/discover_screen.dart';
// import 'package:dating/screens/profile_screens/heartsync_screen.dart';
// import 'package:dating/screens/profile_screens/liked_Screen.dart';
// import 'package:dating/screens/profile_screens/profile_screen.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class CustomBottomNavigationBar extends ConsumerStatefulWidget {
//   const CustomBottomNavigationBar({super.key});

//   @override
//   ConsumerState<CustomBottomNavigationBar> createState() =>
//       _CustomBottomNavigationBarState();
// }

// class _CustomBottomNavigationBarState
//     extends ConsumerState<CustomBottomNavigationBar> {
//   int _selectedIndex = 0;
//   DateTime? _lastBackPressed;

//   int? _resolveModeId(UserModel userModel) {
//     final data = userModel.data;
//     if (data == null || data.isEmpty) return null;
//     final user = data.first.user;
//     if (user == null) return null;

//     // Prefer a single field if present; else fall back to first mode.id
//     final single = (user as dynamic?)?.modeId as int?;
//     if (single != null) return single;

//     final modes = user.modes;
//     if (modes != null && modes.isNotEmpty) return modes.first.id;
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userModel = ref.watch(loginProvider);
//     final modeId = _resolveModeId(userModel);

//     // Build tabs dynamically so icons and pages stay in sync.
//     final tabs = <_TabSpec>[
//       _TabSpec(
//         page: ProfileScreen(),
//         asset: 'assets/Profile-.png',
//         w: 50,
//         h: 55,
//       ),
//       if (modeId == 4)
//         _TabSpec(
//           page: DiscoverScreen(),
//           asset: 'assets/good_logo.png',
//           w: 40,
//           h: 50,
//         ),
//       _TabSpec(
//         page: MyHeartsyncPage(),
//         asset: 'assets/peoples-.png',
//         w: 50,
//         h: 55,
//       ),
//       _TabSpec(
//         page: LikedYouScreen(),
//         asset: 'assets/Heart@3x.png',
//         w: 40,
//         h: 50,
//       ),
//       _TabSpec(
//         page: MessagesScreen(),
//         asset: 'assets/chatnav.png',
//         w: 40,
//         h: 50,
//       ),
//     ];

//     // Clamp selected index in case tab count changes (e.g., when modeId loads)
//     final currentIndex =
//         _selectedIndex.clamp(0, tabs.length - 1).toInt();

//     return PopScope(
//       canPop: false,
//       onPopInvokedWithResult: (didPop, result) async {
//         if (didPop) return;

//         final now = DateTime.now();
//         if (_lastBackPressed == null ||
//             now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
//           _lastBackPressed = now;
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Tap again to exit app'),
//               duration: Duration(seconds: 2),
//             ),
//           );
//         } else {
//           await SystemNavigator.pop();
//         }
//       },
//       child: Scaffold(
//         body: IndexedStack(
//           index: currentIndex,
//           children: tabs.map((t) => t.page).toList(),
//         ),
//         bottomNavigationBar: Container(
//           height: 60,
//           padding: const EdgeInsets.symmetric(horizontal: 8),
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               for (int i = 0; i < tabs.length; i++)
//                 _buildNavItem(
//                   i,
//                   tabs[i].asset,
//                   tabs[i].w,
//                   tabs[i].h,
//                   isSelected: i == currentIndex,
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _onItemTapped(int index) {
//     if (index == _selectedIndex) return;
//     setState(() => _selectedIndex = index);
//   }

//   Widget _buildNavItem(
//     int index,
//     String assetPath,
//     double width,
//     double height, {
//     required bool isSelected,
//   }) {
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
//             color: isSelected
//                 ? const Color.fromARGB(255, 91, 110, 4)
//                 : null,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _TabSpec {
//   final Widget page;
//   final String asset;
//   final double w;
//   final double h;
//   _TabSpec({required this.page, required this.asset, required this.w, required this.h});
// }































// import 'package:dating/provider/loginProvider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:dating/screens/profile_screens/message_screen.dart';
// import 'package:dating/screens/profile_screens/discover_screen.dart';
// import 'package:dating/screens/profile_screens/heartsync_screen.dart';
// import 'package:dating/screens/profile_screens/liked_Screen.dart';
// import 'package:dating/screens/profile_screens/profile_screen.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class CustomBottomNavigationBar extends ConsumerStatefulWidget {
//   const CustomBottomNavigationBar({super.key});

//   @override
//   ConsumerState<CustomBottomNavigationBar> createState() =>
//       _CustomBottomNavigationBarState();
// }

// class _CustomBottomNavigationBarState
//     extends ConsumerState<CustomBottomNavigationBar> {
//   int _selectedIndex = 0;
//   DateTime? _lastBackPressed;

//   // Safely get modeId from the user model.
//   int? _readModeId() {
//     final userModel = ref.read(loginProvider);
//     // // Try a single field first (if your API sends user.modeId)
//     // final single = userModel.data!.isNotEmpty ? userModel.data!.first.user?.modeId : null;
//     // if (single != null) return single;

//     // Otherwise fall back to the first item in user.modes
//     final modes = userModel.data!.isNotEmpty ? userModel.data!.first.user?.modes : null;
//     if (modes != null && modes.isNotEmpty) return modes.first.id;

//     return null;
//   }

//   void _onItemTapped(int index) {
//     // Block Discover tab if modeId != 4
//     if (index == 1) {
//       final modeId = _readModeId();
//       if (modeId != 4) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Discover is available only DATE mode")),
//         );
//         return;
//       }
//     }

//     if (index == _selectedIndex) return;
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Watch so UI updates if login state changes
//     final userModel = ref.watch(loginProvider);
//     // Resolve modeId with same logic used in _readModeId
//     final modeId = userModel.data!.isNotEmpty ? userModel.data?.first.user?.modes!.first.id:null;
            

//     // Build pages: keep 5 tabs. Slot 1 is conditional.
//     final pages = <Widget>[
//       ProfileScreen(),
//       if(modeId == 4) DiscoverScreen(),
//       MyHeartsyncPage(),
//       LikedYouScreen(),
//       MessagesScreen(),
//     ];

//     return PopScope(
//       canPop: false,
//       onPopInvokedWithResult: (didPop, result) async {
//         if (didPop) return;

//         final now = DateTime.now();
//         if (_lastBackPressed == null ||
//             now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
//           _lastBackPressed = now;
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Tap again to exit app'),
//               duration: Duration(seconds: 2),
//             ),
//           );
//         } else {
//           await SystemNavigator.pop();
//         }
//       },
//       child: Scaffold(
//         body: IndexedStack(
//           index: _selectedIndex,
//           children: pages,
//         ),
//         bottomNavigationBar: Container(
//           height: 60,
//           padding: const EdgeInsets.symmetric(horizontal: 8),
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildNavItem(0, 'assets/Profile-.png', 50, 55),
//               _buildNavItem(1, 'assets/good_logo.png', 40, 50),
//               _buildNavItem(2, 'assets/peoples-.png', 50, 55),
//               _buildNavItem(3, 'assets/Heart@3x.png', 40, 50),
//               _buildNavItem(4, 'assets/chatnav.png', 40, 50),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildNavItem(int index, String assetPath, double width, double height,
//       {bool disabled = false}) {
//     final isSelected = index == _selectedIndex;

//     return GestureDetector(
//       onTap: disabled ? null : () => _onItemTapped(index),
//       child: SizedBox(
//         width: 60,
//         height: 60,
//         child: Center(
//           child: Opacity(
//             opacity: disabled ? 0.4 : 1.0,
//             child: Image.asset(
//               assetPath,
//               width: width,
//               height: height,
//               fit: BoxFit.contain,
//               color: isSelected
//                   ? const Color.fromARGB(255, 91, 110, 4)
//                   : null,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }






















import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:flutter/material.dart';
// Import your actual screens here
import 'package:flutter/services.dart'; 
import 'package:dating/screens/profile_screens/message_screen.dart';
import 'package:dating/screens/profile_screens/discover_screen.dart';
import 'package:dating/screens/profile_screens/heartsync_screen.dart';
import 'package:dating/screens/profile_screens/liked_Screen.dart';
import 'package:dating/screens/profile_screens/profile_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dating/constants/dating_app_user.dart';

class CustomBottomNavigationBar extends ConsumerStatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  ConsumerState<CustomBottomNavigationBar> createState() =>_CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends ConsumerState<CustomBottomNavigationBar> {

  int _selectedIndex = 0;
  DateTime? _lastBackPressed;

    @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final usermodel =ref.read(loginProvider);
      // final modeid =usermodel.data[0]?.user[0]?.modes.first.id;
    });
  }
  
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
            color: isSelected 
                ? DatingColors.qpidColor     // icon color selected
                : DatingColors.lightgrey,
          ),
        ),
      ),
    );
  }

//   Widget _buildNavItem(int index, String assetPath, double width, double height) {
//   final isSelected = index == _selectedIndex;

//   return GestureDetector(
//     onTap: () => _onItemTapped(index),
//     child: SizedBox(
//       width: 60,
//       height: 60,
//       child: Center(
//         child: Container(
//           padding: const EdgeInsets.all(8),
//           // decoration: BoxDecoration(
//           //   color: isSelected 
//           //       ? DatingColors.lightpinks   // background for selected
//           //       : Colors.transparent,
//           //   shape: BoxShape.circle,
//           // ),
//           child: Image.asset(
//             assetPath,
//             width: width,
//             height: height,
//             fit: BoxFit.contain,
//             color: isSelected 
//                 ? DatingColors.qpidColor     // icon color selected
//                 : DatingColors.lightgrey,    // icon color unselected
//           ),
//         ),
//       ),
//     ),
//   );
// }

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
