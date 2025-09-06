import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/googe_sign_provider.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/screens/location_screen.dart';
import 'package:dating/screens/profile_screens/profile_bottomNavigationbar.dart';
import 'package:dating/screens/profile_screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dating/screens/logins/loginscreen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';


class SelectPage extends ConsumerStatefulWidget {
  const SelectPage({super.key});

  @override
  ConsumerState<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends ConsumerState<SelectPage> {
  
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    final isSmallScreen = screenWidth < 375;

    return Scaffold(
      backgroundColor: DatingColors.white,
      body: Column(
        children: [
          _buildImageSection(screenWidth, screenHeight, isSmallScreen),
          // const Spacer(),
          SizedBox(height: isSmallScreen ? 35 : 20),
          _buildButtons(context, screenWidth, isSmallScreen),
          SizedBox(height: isSmallScreen ? 15 : 20),
          _buildDisclaimerText(screenWidth),
          SizedBox(height: isSmallScreen ? 15 : 20),
        ],
      ),
    );
  }

  /// Top Image Section
  Widget _buildImageSection(double screenWidth, double screenHeight, bool isSmallScreen) {
    final containerHeight = isSmallScreen ? screenHeight * 0.55 : screenHeight * 0.60;
    final mainImageWidth = screenWidth * 0.6;
    final mainImageHeight = containerHeight * 0.7;
    final smallImageSize = isSmallScreen ? 45.0 : 60.0;

    return Container(
      width: double.infinity,
      height: containerHeight,
      decoration: 
      const BoxDecoration(
        // gradient: LinearGradient(
          // colors: [DatingColors.lightpink, DatingColors.everqpidColor],
          image:const DecorationImage(
      image: AssetImage("assets/everqpidbg.png"), // your image path
      fit: BoxFit.cover, // cover, contain, fill, etc.
    ),
          // stops: [0.0, 1.0],
          // begin: AlignmentDirectional(0.0, -1.0),
          // end: AlignmentDirectional(0, 1.0),
        // ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40.0),
          bottomRight: Radius.circular(40.0),
        ),
      ),
      
      
      
      
      child: Stack(

        children: [
          // Positioned.fill(
          //   child: Image.asset(
          //     "assets/everqpidbg.png",
          //     fit: BoxFit.cover,
          //   ),
          // ),
          Align(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                'assets/everlogo.png',
                width: mainImageWidth,
                height: mainImageHeight,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Align(
          //   alignment: AlignmentDirectional(0.60, -0.55),
          //   child: ClipRRect(
          //     borderRadius: BorderRadius.circular(8.0),
          //     child: Image.asset(
          //       'assets/Frame_1597886617.png',
          //       width: smallImageSize,
          //       height: smallImageSize,
          //       fit: BoxFit.contain,
          //     ),
          //   ),
          // ),
          // Align(
          //   alignment: AlignmentDirectional(-0.60, 0.55),
          //   child: ClipRRect(
          //     borderRadius: BorderRadius.circular(8.0),
          //     child: Image.asset(
          //       'assets/Frame_1597886617.png',
          //       width: smallImageSize,
          //       height: smallImageSize,
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  /// Social Login Buttons
  Widget _buildButtons(BuildContext context, double screenWidth, bool isSmallScreen) {
    final horizontalPadding = screenWidth * 0.08;
    final buttonSpacing = isSmallScreen ? 10.0 : 12.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        children: [
          _buildSocialButton(
            "Continue With Google",
            null,
            DatingColors.errorRed,
            screenWidth,
            isSmallScreen,
            () async {
              final controller = ref.read(googleSignInControllerProvider);
              final userCredential = await controller.signInWithGoogle();

              if (userCredential != null && userCredential.user?.email != null) {
                final email = userCredential.user!.email!;
                final statusCode = await ref.read(loginProvider.notifier).sendemailToAPI(email);

                if (statusCode == 200 || statusCode == 201) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Welcome $email!")),
                  );
                  Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => CustomBottomNavigationBar()),
                            (route) => false, // remove all previous screens
                          );
                } else if (statusCode == 404) {
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(content: Text("user not found,Please signup.")),
                  // );
                   Navigator.pushNamed(
                        context,
                        '/locationScreen',
                        arguments: {
                          'email': email,
                        
                        },
                      );
                //  Navigator.push(context,MaterialPageRoute(builder: (context) => LocationScreen()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Server error ($statusCode). Please try again later.")),
                  );
                  // stay on the same screen
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Google Sign-In failed")),
                );
              }
            },

            image: SvgPicture.asset(
              'assets/google_logo.svg',
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
           
              () async {
                  try {
                    final LoginResult result = await FacebookAuth.instance.login();

                    if (!context.mounted) return; // 🔐 protect context after await

                    if (result.status == LoginStatus.success) {
                      final userData = await FacebookAuth.instance.getUserData(fields: "email,name");

                      final email = userData['email'];
                      if (email != null) {
                        final statusCode = await ref.read(loginProvider.notifier).sendemailToAPI(email);

                        if (!context.mounted) return; // 🔐 again after await

                        if (statusCode == 200 || statusCode == 201) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Welcome $email!")),
                          );
                           Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => CustomBottomNavigationBar()),
                            (route) => false, // remove all previous screens
                          );
                        } else if (statusCode == 404) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("user not found,Please signup.")),
                          );
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LocationScreen()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Server error ($statusCode). Please try again later.")),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Email not available from Facebook account.")),
                        );
                      }
                    } else if (result.status == LoginStatus.cancelled) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Facebook login cancelled")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Facebook login failed: ${result.message}")),
                      );
                      print('............$result');
                    }
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Facebook login error: $e")),
                    );
                    print('............$e');
                  }
                },

            //   print("Facebook Login Clicked");
            // },
            icon: Icons.facebook,
          ),
          SizedBox(height: buttonSpacing),
          _buildSocialButton(
            "Use Mobile Number",
            null,
            DatingColors.everqpidColor,
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

  /// Social Button Generator
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
          color: DatingColors.primaryGreen,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color:DatingColors.white,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:DatingColors.backgroundWhite,
          foregroundColor:DatingColors.everqpidColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        ),
        child: Row(
          children: [
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
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  color: DatingColors.everqpidColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Disclaimer
  Widget _buildDisclaimerText(double screenWidth) {
    final horizontalPadding = screenWidth * 0.08;
    final fontSize = screenWidth < 375 ? 11.0 : 12.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Text(
        "By signing up, you agree to our Terms. See \n how we use your data in our Privacy \n Policy. We never post to Facebook.",
        textAlign: TextAlign.center,
        maxLines: 3,
        style: TextStyle(
          fontSize: fontSize,
          color: DatingColors.brown,
        ),
      ),
    );
  }
}
