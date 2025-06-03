import 'package:dating/screens/FriendOnboardingScreen.dart';
import 'package:flutter/material.dart';

class BeKindScreen extends StatelessWidget {
  const BeKindScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const Drawer(), // optional drawer icon support
      appBar: AppBar(
        title: const Text(
          'Ever Qupid',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Stack(
                alignment: Alignment.center,
                children: [
                  // Positioned(
                  //   top: 35,
                  //   right: -30,
                  //   child: Transform.rotate(
                  //     angle: -0.5,
                  //     child: Container(
                  //       width: 150,
                  //       height: 20,
                  //       color: const Color(0xFFB6D472),
                  //     ),
                  //   ),
                  // ),
                  const CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage('assets/acceptImage.png'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "It’s Cool To Be Kind",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 16),
              const Text(
                "We're All About Equality In Relationships. Here, We Hold People Accountable For The Way They Treat Each Other.\n\n"
                "We Ask Everyone On Heart Sync To Be Kind And Respectful, So Every Person Can Have A Great Experience.\n\n"
                "By Using Heart Sync, You’re Agreeing To Adhere To Our Values As Well As Our ",
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                ),
                textAlign: TextAlign.start,
              ),
              const Text(
                "Guidelines.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  // Handle accept
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => FriendOnboardingScreen()));
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF869E23), Color(0xFF000000)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "I Accept",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
