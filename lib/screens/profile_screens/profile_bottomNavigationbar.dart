import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({Key? key, required this.currentIndex})
      : super(key: key);

  void _onTabTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, 'profilescreen');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, 'discoverscreen');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, 'myheartsyncpage');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, 'likedyouscreen');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, 'messagescreen');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, 0, 'assets/campusnav.png', 64, 84),
          _buildNavItem(context, 1, 'assets/profilenav.png', 64, 84),
          _buildNavItem(context, 2, 'assets/peoplesnav.png', 40, 40),
          _buildNavItem(context, 3, 'assets/heartnav.png', 40, 40),
          _buildNavItem(context, 4, 'assets/chatnav.png', 40, 40),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, String assetPath, double width, double height) {
    final isSelected = index == currentIndex;
    return GestureDetector(
      onTap: () => _onTabTapped(context, index),
      child: Image.asset(
        assetPath,
        width: width,
        height: height,
        color: isSelected ? Color.fromARGB(255, 16, 20, 2) : null, // Optional tint for selected
      ),
    );
  }
}
