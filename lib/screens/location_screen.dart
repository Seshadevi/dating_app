import 'package:dating/constants/dating_app_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'notification_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

   @override
   State<LocationScreen> createState() => Locationstatescreen();
 }

 class Locationstatescreen extends State<LocationScreen> { 
   String? email;
   String? mobile;
 
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null ) { // Prevent overwriting selected products
      setState(() {
         email = args['email'] ?? '';
         mobile= args['mobile'] ?? '';
     
      });
    }
  }

  Future<void> _handleLocationPermissionAndNavigate(BuildContext context) async {
      bool serviceEnabled;
      LocationPermission permission;
  

      // 1. Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return;
      }

      // 2. Check permission status
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        return;
      }

      // 3. Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

    // 4. Pass location to next screen
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => AllowNotification(
    //       latitude: position.latitude,
    //       longitude: position.longitude,
    //     ),
    //   ),
    // );

       Navigator.pushNamed(
                        context,
                        '/allownotification',
                        arguments: {
                          'latitude': position.latitude,
                          'longitude':position.longitude,
                          'email':email,
                          'mobile':mobile
                        },
                      );
     }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: DatingColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Background image covering entire screen
            Positioned.fill(
              child: Image.asset(
                "assets/everqpidbg.png",
                fit: BoxFit.cover,
              ),
            ),
            
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height * 0.22),
                  Text(
                    "Location Access",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: height * 0.039,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: height * 0.04),
                  Text(
                    "It helps us find people who match your vibe, near or far.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: height * 0.022,
                      color: DatingColors.brown,
                      height: 1.5,
                    ),
                  ),
                  const Spacer(),

                  /// ✅ Set Location Services Button
                  SizedBox(
                    width: double.infinity,
                    height: height * 0.065,
                    child: ElevatedButton(
                      onPressed: () => _handleLocationPermissionAndNavigate(context),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [DatingColors.lightpinks, DatingColors.everqpidColor],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            "Set Location Services",
                            style: TextStyle(
                              color: DatingColors.brown,
                              fontSize: height * 0.022,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02),

                  /// Not Now
                  // TextButton(
                  //   onPressed: () {
                   
                  //     Navigator.pushNamed(
                  //       context,
                  //       '/allownotification',
                  //       arguments: {
                  //         'latitude': 0.0,
                  //         'longitude':0.0,
                  //         'email':email,
                  //         'mobile':mobile
                  //       },
                  //     );        
                  //          },
                    
                  //   child: Text(
                  //     "Not Now",
                  //     style: TextStyle(
                  //       fontSize: height * 0.018,
                  //       color: DatingColors.brown,
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: height * 0.03),
                ],
              ),
            ),

            /// Circle image
            // Positioned(
            //   top: height * 0.02,
            //   right: 0,
              // child: Container(
              //   height: height * 0.18,
              //   width: height * 0.18,
              //   decoration: const BoxDecoration(
              //     color: DatingColors.surfaceGrey,
              //     shape: BoxShape.circle,
              //   ),
                // child: Image.asset(
                  // 'assets/allow_location.png',
                  // height: height * 0.12,
                  // width: height * 0.12,
                  // fit: BoxFit.contain,
                // ),
              // ),
            // ),
          ],
        ),
      ),
    );
  }
}