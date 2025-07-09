import 'package:dating/screens/profile_screens/favourate.dart';
import 'package:dating/screens/profile_screens/profile_bottomNavigationbar.dart';
import 'package:flutter/material.dart';

class LikedYouScreen extends StatelessWidget {
  const LikedYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Liked You',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
           const SizedBox(height: 20),
            const Text(
              "When People Are Into You, They’ll \nAppear Here.\nEnjoy.",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 32),
            Image.asset(
              'assets/liked_image.png', // replace with your image asset
              height: 200,
            ),
            const SizedBox(height: 180),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFB0E300), Colors.black],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextButton(
                onPressed: () {
                  // Add your action here
                  Navigator.push(context, MaterialPageRoute(builder:(context) => FavoritesScreen(),));
                },
                child: const Text(
                  "Try A Spotlight",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 3,),
    );
  }
}

