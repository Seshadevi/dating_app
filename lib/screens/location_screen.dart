import 'package:flutter/material.dart';
import '../screens/notification_screen.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            /// Main Content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height * 0.22),

                  /// Title
                  Text(
                    "Now, Can We Get Your\nLocation?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: height * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: height * 0.02),

                  /// Description
                  Text(
                    "We need it so we can show you\nall the great people nearby (or far away)",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: height * 0.022,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),

                  const Spacer(),

                  /// Set Location Services Button
                  SizedBox(
                    width: double.infinity,
                    height: height * 0.065,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AllowNotification()),
                        );
                      },
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
                            colors: [Color(0xFFB9D83F), Colors.black],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            "Set Location Services",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: height * 0.022,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.02),

                  /// Not Now
                  TextButton(
                    onPressed: () {
                      // Navigation for skipping
                    },
                    child: Text(
                      "Not Now",
                      style: TextStyle(
                        fontSize: height * 0.018,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.03),
                ],
              ),
            ),

            /// Positioned circular image at top-right
            Positioned(
              top: height * 0.02,
              right: 0,
              child: Container(
                height: height * 0.18,
                width: height * 0.18,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0F0F0),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/allow_location.png', // Make sure this asset exists
                  height: height * 0.12,
                  width: height * 0.12,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showFakeLocationPopup(BuildContext context, LocationViewModel viewModel) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFFE9F3C6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: height * 0.03,
            horizontal: width * 0.05,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on, size: height * 0.04, color: Colors.black),
              SizedBox(height: height * 0.02),
              Text(
                "Allow Heart Sync To\nAccess This Device’s Location?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: height * 0.022,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: height * 0.025),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  viewModel.onLocationOptionSelected("While Using The App");
                },
                child: Text(
                  "While Using The App",
                  style: TextStyle(fontSize: height * 0.02),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  viewModel.onLocationOptionSelected("Only This Time");
                },
                child: Text(
                  "Only This Time",
                  style: TextStyle(fontSize: height * 0.02),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  viewModel.onLocationOptionSelected("Don’t Allow");
                },
                child: Text(
                  "Don’t Allow",
                  style: TextStyle(
                    fontSize: height * 0.02,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LocationViewModel {
  void onLocationOptionSelected(String option) {
    print('Location option selected: $option');
  }
}
