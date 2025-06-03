import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dating/screens/logins/loginscreen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SelectPage extends ConsumerWidget {
  const SelectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get screen dimensions using MediaQuery
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    // Define responsive breakpoints
    final isSmallScreen = screenWidth < 375;
    final isMediumScreen = screenWidth >= 375 && screenWidth < 768;
    final isLargeScreen = screenWidth >= 768;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildImageSection(screenWidth, screenHeight, isSmallScreen),
          const Spacer(),
          _buildButtons(context, screenWidth, isSmallScreen),
          SizedBox(height: isSmallScreen ? 15 : 20),
          _buildDisclaimerText(screenWidth),
          SizedBox(height: isSmallScreen ? 15 : 20),
        ],
      ),
    );
  }

  /// **Image Section with Responsive Design**
  Widget _buildImageSection(double screenWidth, double screenHeight, bool isSmallScreen) {
    // Calculate responsive dimensions
    final containerHeight = isSmallScreen
        ? screenHeight * 0.55  // 55% of screen height for small screens
        : screenHeight * 0.60; // 60% for larger screens

    final mainImageWidth = screenWidth * 0.6; // 60% of screen width
    final mainImageHeight = containerHeight * 0.7; // 70% of container height

    final smallImageSize = isSmallScreen ? 45.0 : 60.0;

    return Container(
      width: double.infinity,
      height: containerHeight,
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
                width: mainImageWidth,
                height: mainImageHeight,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0.60, -0.55),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                'assets/Frame_1597886617.png',
                width: smallImageSize,
                height: smallImageSize,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(-0.60, 0.55),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                'assets/Frame_1597886617.png',
                width: smallImageSize,
                height: smallImageSize,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// **Buttons Section with Responsive Design**
  Widget _buildButtons(BuildContext context, double screenWidth, bool isSmallScreen) {
    final horizontalPadding = screenWidth * 0.08; // 8% of screen width
    final buttonSpacing = isSmallScreen ? 10.0 : 12.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        children: [
          _buildSocialButton(
            "Continue With Google",
            null,
            const Color(0xffDB4437),
            screenWidth,
            isSmallScreen,
                () {
              print("Google Login Clicked");
            },
            image: Image.asset(
              'assets/google.png',
              width: isSmallScreen ? 20 : 24,
              height: isSmallScreen ? 20 : 24,
            ),
          ),
          SizedBox(height: buttonSpacing),
          _buildSocialButton(
            "Continue With Facebook",
            null,
            const Color(0xff4267B2),
            screenWidth,
            isSmallScreen,
                () {
              print("Facebook Login Clicked");
            },
            icon: Icons.facebook,
          ),
          SizedBox(height: buttonSpacing),
          _buildSocialButton(
            "Use Mobile Number",
            null,
            const Color(0xff25D366),
            screenWidth,
            isSmallScreen,
                () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
              print("Mobile Login Clicked");
            },
            icon: Icons.phone_android,
          ),
        ],
      ),
    );
  }

  /// **Responsive Social Button**
  Widget _buildSocialButton(
      String text,
      String? svgAsset,
      Color accentColor,
      double screenWidth,
      bool isSmallScreen,
      VoidCallback onPressed, {
        IconData? icon,
        Widget? image,
      }) {

    final buttonHeight = isSmallScreen ? 50.0 : 56.0;
    final borderRadius = buttonHeight / 2;
    final fontSize = isSmallScreen ? 14.0 : 16.0;
    final iconSize = isSmallScreen ? 20.0 : 24.0;

    return Container(
      width: double.infinity,
      height: buttonHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: const Color(0xffB2D12E),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, // 5% of screen width
          ),
        ),
        child: Row(
          children: [
            // Icon/Logo/Image
            if (image != null)
              image
            else if (svgAsset != null)
              SvgPicture.asset(
                svgAsset,
                width: iconSize,
                height: iconSize,
                colorFilter: ColorFilter.mode(accentColor, BlendMode.srcIn),
              )
            else if (icon != null)
                Icon(
                  icon,
                  color: accentColor,
                  size: iconSize,
                ),

            SizedBox(width: screenWidth * 0.04), // 4% of screen width

            // Text
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// **Responsive Disclaimer Text**
  Widget _buildDisclaimerText(double screenWidth) {
    final horizontalPadding = screenWidth * 0.08; // 8% of screen width
    final fontSize = screenWidth < 375 ? 11.0 : 12.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Text(
        "by signing up, you agree to our terms. see \n how we use your data in our privacy \n policy. we never post to facebook.",
        textAlign: TextAlign.center,
        maxLines: 3,
        style: TextStyle(
          fontSize: fontSize,
          color: const Color.fromARGB(179, 29, 28, 28),
        ),
      ),
    );
  }
}

// Alternative approach using LayoutBuilder for more precise control
class SelectPageAlternative extends ConsumerWidget {
  const SelectPageAlternative({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          return Column(
            children: [
              _buildImageSection(screenWidth, screenHeight),
              const Spacer(),
              _buildButtons(context, screenWidth),
              const SizedBox(height: 20),
              _buildDisclaimerText(screenWidth),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  Widget _buildImageSection(double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      height: screenHeight * 0.6, // 60% of available height
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xffB2D12E), Color(0xff000000)],
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
      // Stack content here...
    );
  }

  Widget _buildButtons(BuildContext context, double screenWidth) {
    // Responsive button implementation
    return Container(); // Placeholder
  }

  Widget _buildDisclaimerText(double screenWidth) {
    // Responsive disclaimer implementation
    return Container(); // Placeholder
  }
}