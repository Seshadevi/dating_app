import 'package:flutter/material.dart';
import '../screens/notification_screen.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 200), // Space for the top-right icon

                  /// Title
                  const Text(
                    "Now, Can We Get Your\nLocation?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Description
                  const Text(
                    "We need it so we can show you\nall the great people nearby (or far away)",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),

                  const Spacer(),

                  /// Set Location Services Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Replace `viewModel` with actual state management solution
                        // final viewModel = LocationViewModel();
                        // showFakeLocationPopup(context, viewModel);
                         Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AllowNotification()));
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
                        child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            "Set Location Services",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Not Now
                  TextButton(
                    onPressed: () {
                      // // Skip location setting
                      //  Navigator.push(
                      //       context,
                      //       MaterialPageRoute(builder: (context) => OnboardingScreen()),
                      //       //  MaterialPageRoute(builder: (context) => OnboardingScreen()),
                      //     );
                    },
                    child: const Text(
                      "Not Now",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),

            // Positioned circular icon at top-right
            Positioned(
              top: 20,
              right: 0,
              child: Container(
                height: 150,
                width: 150,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0F0F0),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/allow_location.png', // Replace with your actual image path
                  height: 100,
                  width: 100,
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
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFFE9F3C6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_on, size: 28, color: Colors.black),
              const SizedBox(height: 16),
              const Text(
                "Allow Heart Sync To\nAccess This Device’s Location?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  viewModel.onLocationOptionSelected("While Using The App");
                },
                child: const Text("While Using The App"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  viewModel.onLocationOptionSelected("Only This Time");
                },
                child: const Text("Only This Time"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  viewModel.onLocationOptionSelected("Don’t Allow");
                },
                child: const Text(
                  "Don’t Allow",
                  style: TextStyle(color: Colors.redAccent),
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
  // Placeholder for your view model methods
  void onLocationOptionSelected(String option) {
    print('Location option selected: $option');
    // Handle the location permission logic here
  }
}
