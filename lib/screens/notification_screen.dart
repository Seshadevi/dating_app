import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/screens/introPage_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../screens/onboarding_screens.dart'; // Update this import as per your project structure

class AllowNotification extends StatefulWidget {
  

  const AllowNotification({super.key,});

  @override
  State<AllowNotification> createState() => _AllowNotificationState();
}

class _AllowNotificationState extends State<AllowNotification> {

   String? entryemail;
   String? mobile;
   double? latitude;
   double? longitude;
   
   @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null ) { // Prevent overwriting selected products
      setState(() {
         entryemail = args['email'] ?? '';
         mobile= args['mobile'] ?? '';
         latitude=args['latitude'] ?? 0.0;
         longitude=args['longitude']?? 0.0;
     
      });
    }
  }

  Future<void> _handleNotificationPermission(BuildContext context) async {
    final status = await Permission.notification.request();

    if (status.isGranted || status.isLimited) {
      
      Navigator.pushNamed(
          context,
          '/intropage',
          arguments: {
            'latitude': latitude,
            'longitude': longitude,
            'email':entryemail,
            'mobile':mobile
          },
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
            'Enable Notifications',
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
            'So you never miss a \nmatch, like, or message.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter Tight',
              fontSize: 17.0,
              letterSpacing: 1.28,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: screenHeight * 0.21),
          Container(
            height: screenHeight * 0.06,
            width: screenWidth * 0.88,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [DatingColors.primaryGreen,DatingColors.black ],
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
                  color: DatingColors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/intropage',
                  arguments: {
                    'latitude': latitude,
                    'longitude': longitude,
                    'email':entryemail,
                    'mobile':mobile
                  },
                );   
              },
              child: Text(
                'Not Now',
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  color: DatingColors.black,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
