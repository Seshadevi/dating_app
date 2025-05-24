import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../widgets/profile_image_widget.dart';
import '../../widgets/button_code.dart';
import '../../Views/select_page.dart';


class JoinPageScreen extends ConsumerWidget {
  const JoinPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF869E23), Color(0xFF000000)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Floating images layout
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Stack(
                  children: const [
                    // First Column
                    ProfileImageWidget(url: "https://randomuser.me/api/portraits/women/1.jpg", top: -30, left: -40, width: 80, height: 130),
                    ProfileImageWidget(url: "https://randomuser.me/api/portraits/men/1.jpg", top: -30, left: 120, width: 80, height: 150),

                    // Second Column
                    ProfileImageWidget(url: "https://randomuser.me/api/portraits/women/2.jpg", top: 90, left: -90, width: 90, height: 150),
                    ProfileImageWidget(url: "https://randomuser.me/api/portraits/men/2.jpg", top: 90, left: 80, width: 90, height: 150),
                    ProfileImageWidget(url: "https://randomuser.me/api/portraits/women/3.jpg", top: 90, left: 240, width: 90, height: 150),

                    // Third Column
                    ProfileImageWidget(url: "https://randomuser.me/api/portraits/men/3.jpg", top: 200, left: 100, width: 70, height: 160),

                    // Fourth Column
                    ProfileImageWidget(url: "https://randomuser.me/api/portraits/women/4.jpg", top: 295, left: -30, width: 70, height: 140),
                    ProfileImageWidget(url: "https://randomuser.me/api/portraits/men/4.jpg", top: 295, left: 120, width: 70, height: 170),
                    ProfileImageWidget(url: "https://randomuser.me/api/portraits/women/5.jpg", top: 295, left: 300, width: 90, height: 170),

                    // Heart icon
                    Positioned(
                      top: 30,
                      right: 100,
                      child: Icon(Icons.favorite_outline_outlined, color: Colors.white, size: 50),
                    ),
                  ],
                ),
              ),
            ),

            // Text + Button Area
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Find your\npartner in life",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "We created to bring together amazing\n"
                      "singles who want to find love, laughter,\n"
                      "and happily ever after!",
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                    const SizedBox(height: 15),
                     // 👇 Add this custom text line here
                      const Text(
                        "Love is just a click away.",
                        style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.white),
                      ),

                      const SizedBox(height: 20),

                     JoinNowButton(
                            buttonText: "Join now",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>SelectPage()),
                              );
                            },
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
}
