import 'package:dating/screens/tab_bar/tabScreen.dart';
import 'package:flutter/material.dart';
import '../screens/glitchScreen.dart';

class FriendOnboardingScreen extends StatelessWidget {
  const FriendOnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
             Positioned(
              top: 90,
              left: -10, // Adjust this to move it to the left
              child: SizedBox(
                height: 280,
                child: Image.asset(
                  'assets/womenback.jpg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Positioned image
            Stack(
  children: [
    Positioned(
      top: 10,
      left: -10,
      child: SizedBox(
        height: 350,
        child: Image.asset(
          'assets/women.png',
          fit: BoxFit.contain,
        ),
      ),
    ),
  ],
),


            // Main content
            Column(
              children: [
                const SizedBox(height: 400), // Adjust based on image height
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Make New Friends At Every Stage Of Your Life',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'BFF will help you find new friendships, whether you’re new to a city or just looking to expand your social circle.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => 
                            SubscriptionTabScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                      child: Ink(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFB6D96E), Color(0xFF000000)],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: const Center(
                          child: Text(
                            'Got It',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
