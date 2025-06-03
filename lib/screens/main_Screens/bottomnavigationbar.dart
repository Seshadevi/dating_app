import 'package:flutter/material.dart';
import '../main_Screens/chatScreen.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  void _onItemTapped(BuildContext context, int index) {
    // Define your screen routes or direct widget navigation here
    Widget destinationScreen;

    switch (index) {
      case 0:
        // destinationScreen = HomeScreen(); // your home screen widget
        break;
      case 1:
        // destinationScreen = LikesScreen(); // your likes screen widget
        break;
      case 2:
        // destinationScreen = ProfileScreen(); // your profile screen widget
        break;
      case 3:
        destinationScreen = ChatScreen(); // your chat screen widget
        break;
      default:
        return;
    }

    // Navigate replacing current screen
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (_) => destinationScreen),
    // );
  }

  @override
  Widget build(BuildContext context) {
    // Optionally detect current route and set current index accordingly
    int currentIndex = 0; // Or determine from current route

    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.black,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (index) => _onItemTapped(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: "Likes",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: "Profile",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: "Chat",
        ),
      ],
    );
  }
}
