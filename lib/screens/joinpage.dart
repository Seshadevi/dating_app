import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dating/screens/Entryselection_page.dart';
import '../screens/onboarding_screens.dart';

class JoinPageScreen extends ConsumerWidget {
  const JoinPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            // colors: [Color(0xFF00A878), Color(0xFF028090)],
            colors: [Color(0xFF869E23), Color(0xFF000000)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Floating Images
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Stack(
                  children: [
                    // First Column (2 images, partially out on top)
                    _profileImage("https://randomuser.me/api/portraits/women/1.jpg", -30, -40, 80, 130),
                    _profileImage("https://randomuser.me/api/portraits/men/1.jpg", 120, -40, 80, 150),

                    // Second Column (3 images)
                    _profileImage("https://randomuser.me/api/portraits/women/2.jpg", -90, 90, 90, 150),
                    _profileImage("https://randomuser.me/api/portraits/men/2.jpg", 80, 90, 90, 150),
                    _profileImage("https://randomuser.me/api/portraits/women/3.jpg", 240, 90, 90, 150),

                    // Third Column (1 image)
                    _profileImage("https://randomuser.me/api/portraits/men/3.jpg", 100, 200, 70, 160),

                    // Fourth Column (3 images, last partially out on bottom)
                    _profileImage("https://randomuser.me/api/portraits/women/4.jpg", -30, 295, 70, 140),
                    _profileImage("https://randomuser.me/api/portraits/men/4.jpg", 120, 295, 70, 170),
                    _profileImage("https://randomuser.me/api/portraits/women/5.jpg", 300, 295, 90, 170),

                    // Heart Symbol
                    Positioned(
                      top: 30,
                      right: 100,
                      child: Image.asset('assets/Vector.png')
                    ),
                  ],
                ),
              ),
            ),

            // Main Content
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Ensures no extra space
                  crossAxisAlignment: CrossAxisAlignment.start, // Aligns text to the left
                  children: [
                    // Title
                    const Text(
                      "Find your\npartner in life",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Subtitle
                    const Text(
                      "We created to bring together amazing\n"
                      "singles who want to find love, laughter,\n"
                      "and happily ever after!",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Join Now Button
                    SizedBox(
                      width: double.infinity, // Button takes full width
                      height: 60, // Proper button height
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SelectPage()),
                            //  MaterialPageRoute(builder: (context) => OnboardingScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  Color(0xffE9F1C4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            
                          ),
                        ),
                        child: const Text(
                          "Join now",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            // backgroundColor:  Color(0xffE9F1C4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Profile Image Widget with Positioned and Border
  Widget _profileImage(String imageUrl, double top, double left, double width, double height) {
    return Positioned(
      top: top,
      left: left,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 2,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
