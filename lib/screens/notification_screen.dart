import 'package:flutter/material.dart';

import '../screens/onboarding_screens.dart';

class AllowNotification extends StatelessWidget {
  const AllowNotification({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(
                top: screenHeight * 0.1, bottom: screenHeight * 0.04),
            width: screenWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset('assets/allow_notification.png'),
              ],
            ),
          ),
          Text(
            'Don’t Miss A Beat, Or \nA Match',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontFamily: 'Inter Tight',
              fontSize: 27.0,
              letterSpacing: 0.48,
              fontWeight: FontWeight.bold,
              height: 1.32,
            ),
          ),
          Text(
            'Turn On Your Notifications So Se \nCan Let You Know When You \nHave New Matches, Likes, Or \nMessages.',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontFamily: 'Inter Tight',
              fontSize: 17.0,
              letterSpacing: 1.28,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: screenHeight * 0.11),
          Container(
            height: screenHeight * 0.06,
            width: screenWidth * 0.88,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  Color(0xffB2D12E),
                  Color(0xff000000),
                ],
                stops: [0.0, 1.0],
                begin: AlignmentDirectional(0.0, -1.0),
                end: AlignmentDirectional(0, 1.0),
              ),
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OnboardingScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                'Allow Notifications',
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: TextButton(
                onPressed: () {},
                child: Text(
                  'Not Now',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    color: Colors.black,
                  ),
                )),
          )
        ],
      ),
    );
  }
}
