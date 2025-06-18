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
    bool termsAndCondition = isChecked;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Ever Qupid',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                const CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage('assets/acceptImage.png'),
                ),
                const SizedBox(height: 20),
                const Text(
                  "It’s Cool To Be Kind",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 16),
                const Text(
                  "We're All About Equality In Relationships. Here, We Hold People Accountable For The Way They Treat Each Other.\n\n"
                  "We Ask Everyone On Heart Sync To Be Kind And Respectful, So Every Person Can Have A Great Experience.\n\n"
                  "By Using Heart Sync, You’re Agreeing To Adhere To Our Values As Well As Our ",
                  style: TextStyle(
                    fontSize: 14,
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
                  child: const Text(
                    "Guidelines.",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
                  ),
                ),
                if (showTerms) ...[
                  const SizedBox(height: 16),
                  const Text(
                    "Please read and accept the following terms before continuing:",
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "• Treat everyone with kindness and respect.\n"
                      "• Avoid hate speech, harassment, or discrimination.\n"
                      "• Follow community guidelines and be honest.\n"
                      "• Violations may lead to account suspension or removal.",
                      style: TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 10),
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
                      const Expanded(
                        child: Text(
                          "I have read and agree to the terms and conditions.",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ],
                // const Spacer(),
                GestureDetector(
                  onTap: isChecked
                      ? () {
                          print('terms and conditions.....$termsAndCondition');
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
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF869E23), Color(0xFF000000)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "I Accept",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
