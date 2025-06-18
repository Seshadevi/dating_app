import 'package:dating/screens/FriendOnboardingScreen.dart';
import 'package:flutter/material.dart';

class BeKindScreen extends StatefulWidget {
  const BeKindScreen({super.key});

  @override
  State<BeKindScreen> createState() => _BeKindScreenState();
}

class _BeKindScreenState extends State<BeKindScreen> {
  bool showTerms = false;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final double padding = screen.width * 0.05;
    final double titleFontSize = screen.width * 0.055;
    final double bodyFontSize = screen.width * 0.037;
    final double buttonFontSize = screen.width * 0.043;
    final double checkboxFontSize = screen.width * 0.036;

    bool termsAndCondition = isChecked;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Ever Qupid',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: screen.width * 0.045,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screen.height * 0.015),
                CircleAvatar(
                  radius: screen.width * 0.25,
                  backgroundImage: const AssetImage('assets/acceptImage.png'),
                ),
                SizedBox(height: screen.height * 0.025),
                Text(
                  "It’s Cool To Be Kind",
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: screen.height * 0.02),
                Text(
                  "We're All About Equality In Relationships. Here, We Hold People Accountable For The Way They Treat Each Other.\n\n"
                  "We Ask Everyone On Heart Sync To Be Kind And Respectful, So Every Person Can Have A Great Experience.\n\n"
                  "By Using Heart Sync, You’re Agreeing To Adhere To Our Values As Well As Our ",
                  style: TextStyle(
                    fontSize: bodyFontSize,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.start,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showTerms = !showTerms;
                    });
                  },
                  child: Text(
                    "Guidelines.",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                      fontSize: bodyFontSize,
                    ),
                  ),
                ),

                if (showTerms) ...[
                  SizedBox(height: screen.height * 0.02),
                  Text(
                    "Please read and accept the following terms before continuing:",
                    style: TextStyle(fontSize: bodyFontSize),
                  ),
                  SizedBox(height: screen.height * 0.015),
                  Container(
                    padding: EdgeInsets.all(screen.width * 0.04),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "• Treat everyone with kindness and respect.\n"
                      "• Avoid hate speech, harassment, or discrimination.\n"
                      "• Follow community guidelines and be honest.\n"
                      "• Violations may lead to account suspension or removal.",
                      style: TextStyle(fontSize: bodyFontSize, height: 1.5),
                    ),
                  ),
                  SizedBox(height: screen.height * 0.015),
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (val) {
                          setState(() {
                            isChecked = val ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          "I have read and agree to the terms and conditions.",
                          style: TextStyle(fontSize: checkboxFontSize),
                        ),
                      ),
                    ],
                  ),
                ],

                SizedBox(height: screen.height * 0.05),

                // I Accept Button
                GestureDetector(
                  onTap: isChecked
                      ? () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FriendOnboardingScreen(
                                termsAndCondition: termsAndCondition,
                              ),
                            ),
                          );
                        }
                      : null,
                  child: Opacity(
                    opacity: isChecked ? 1.0 : 0.4,
                    child: Container(
                      width: double.infinity,
                      height: screen.height * 0.065,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF869E23), Color(0xFF000000)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "I Accept",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: buttonFontSize,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screen.height * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
