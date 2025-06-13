import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../screens/onboarding_screens.dart'; // Update this import as per your project structure

class AllowNotification extends StatelessWidget {
  final double latitude;
  final double longitude;

  const AllowNotification({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  Future<void> _handleNotificationPermission(BuildContext context) async {
    final status = await Permission.notification.request();

    if (status.isGranted || status.isLimited) {
      // Navigate and pass lat/lng
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OnboardingScreen(
            latitude: latitude,
            longitude: longitude,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification permission not granted'),
        ),
      );
    }
  }

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
              top: screenHeight * 0.1,
              bottom: screenHeight * 0.04,
            ),
            width: screenWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset('assets/allow_notification.png'),
              ],
            ),
          ),
          const Text(
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
          const Text(
            'Turn On Your Notifications So We \nCan Let You Know When You \nHave New Matches, Likes, Or \nMessages.',
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
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [Color(0xffB2D12E), Color(0xff000000)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: ElevatedButton(
              onPressed: () => _handleNotificationPermission(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
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
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OnboardingScreen(
                      latitude: 0.0,
                      longitude: 0.0,
                    ),
                  ),
                );
              },
              child: Text(
                'Not Now',
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  color: Colors.black,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
