import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dating/screens/logins/loginscreen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectPage extends ConsumerWidget {
  const SelectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildImageSection(), // **Fixed Image Section**
          // const Spacer(),
          _buildButtons(context), // **Buttons**
          const SizedBox(height: 20),
          _buildDisclaimerText(), // **Disclaimer**
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// **Image Section Fixed**
  Widget _buildImageSection() {
    return Container(
      width: double.infinity,
      height: 440.0,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xffB2D12E),
            Color(0xff000000),
          ],
          stops: [0.0, 1.0],
          begin: AlignmentDirectional(0.0, -1.0),
          end: AlignmentDirectional(0, 1.0),
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40.0),
          bottomRight: Radius.circular(40.0),
          topLeft: Radius.circular(0.0),
          topRight: Radius.circular(0.0),
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                'assets/Group_1000002551.png',
                width: 250.0,
                height: 375.0,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0.61, -0.7),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                'assets/Frame_1597886617.png',
                width: 60.0,
                height: 60.0,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(-0.64, 0.63),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                'assets/Frame_1597886617.png',
                width: 60.0,
                height: 60.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
    // Container(
    //   width: double.infinity,
    //   height: 450, // Adjusted for perfect fit

    //    decoration: const BoxDecoration(
    //       gradient: LinearGradient(
    //         // colors: [Color(0xFF00A878), Color(0xFF028090)],
    //         colors: [Color(0xFF869E23), Color(0xFF000000)],
    //         begin: Alignment.topLeft,
    //         end: Alignment.bottomRight,
    //       ),
    //        borderRadius: BorderRadius.only(
    //       bottomLeft: Radius.circular(60), // **Rounded Bottom**
    //       bottomRight: Radius.circular(60),
    //     ),

    //     ),
    //   child: Center(
    //     child: ClipRRect(
    //       borderRadius: BorderRadius.circular(20),
    //       child: Image.asset(
    //         "assets/image.png", // **Your Image Path**
    //         width: 290, // Image Size Adjusted
    //         height: 290,
    //         fit: BoxFit.cover,
    //       ),
    //     ),
    //   ),
    // );
  }

  /// **Buttons Section**
  Widget _buildButtons(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        _longButton(
          "Continue With Google",
          SvgPicture.asset(
            'assets/google_logo.svg',
            width: screenWidth * 0.04,
            height: screenHeight * 0.03,
          ),
          () {
            // Your Google Login Logic Here

            print("Google Login Clicked");
          },
        ),
        const SizedBox(height: 1),
        _longButton(
          "Continue With Facebook",
          SvgPicture.asset(
            'assets/google_logo.svg',
            width: screenWidth * 0.04,
            height: screenHeight * 0.03,
          ),
          () {
            // Your Facebook Login Logic Here
            print("Facebook Login Clicked");
          },
        ),
        const SizedBox(height: 1),
        _longButton(
          "Use Mobile Number",
          SvgPicture.asset(
            'assets/google_logo.svg',
            width: screenWidth * 0.04,
            height: screenHeight * 0.03,
          ),
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
            // Your Mobile Number Login Logic Here
            print("Mobile Login Clicked");
          },
        ),
      ],
    );
  }

  /// **Single Long Button**
  Widget _longButton(String text, Widget leading, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 250, 245, 245),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            leading, // 👈 this can be an Image or Icon
            const SizedBox(width: 2),
            Text(
              text,
              style: const TextStyle(
                fontFamily: 'Lexend',
                fontSize: 16.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// **Disclaimer Text**
  Widget _buildDisclaimerText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        "By Signing Up, You Agree To Our Terms. See How We Use Your Data In Our Privacy Policy.",
        textAlign: TextAlign.center,
        maxLines: 3,
        style: const TextStyle(
            fontSize: 12, color: Color.fromARGB(179, 29, 28, 28)),
      ),
    );
  }
}
