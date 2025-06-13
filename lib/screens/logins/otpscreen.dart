import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../location_screen.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key, required String phoneNumber});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController otpController = TextEditingController();
  int _start = 25;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        timer.cancel();
        _showOptionsPopup();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Back Button
              IconButton(
                icon: Icon(Icons.arrow_back_ios, size: height * 0.025),
                onPressed: () => Navigator.pop(context),
              ),

              SizedBox(height: height * 0.01),

              /// Title
              Text(
                "Veryfy Your Number",
                style: TextStyle(
                  fontSize: height * 0.032,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: height * 0.01),

              /// Description
              Text(
                "Enter The Code We've Sent By\nText To +918667238534.",
                style: TextStyle(fontSize: height * 0.022),
              ),
              SizedBox(height: height * 0.008),

              /// Change Number link
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  "Change Number",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: height * 0.018,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

              SizedBox(height: height * 0.03),

              /// Code field
              PinCodeTextField(
                appContext: context,
                length: 6,
                controller: otpController,
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8),
                  fieldHeight: height * 0.065,
                  fieldWidth: width * 0.11,
                  activeColor: const Color(0xFF869E23),
                  selectedColor: const Color(0xFF869E23),
                  inactiveColor: Colors.grey,
                ),
                onChanged: (value) {
                  if (value.length == 6) {
                    _timer?.cancel();
                  }
                },
              ),

              SizedBox(height: height * 0.015),

              /// Timer and Arrow Button
              Row(
                children: [
                  Text(
                    "This Code Should Arrive Within ${_start}s",
                    style: TextStyle(
                      fontSize: height * 0.017,
                      color: Colors.grey,
                    ),
                  ),
                  const Spacer(),

                  /// Arrow icon button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LocationScreen(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      padding: EdgeInsets.all(height * 0.012),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: height * 0.022,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Bottom popup after timer ends or triggered manually
  void _showOptionsPopup() {
    final height = MediaQuery.of(context).size.height;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            gradient: LinearGradient(
              colors: [Color(0xFFB9D83F), Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: height * 0.025),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _popupOption("Send Code Again", () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("New code will be sent again.")),
                );
              }),
              _popupOption("Change Number", () {
                Navigator.pop(context);
                Navigator.pop(context);
              }),
              _popupOption("Get A Phone Call Instead", () {
                Navigator.pop(context);
              }),
              _popupOption("Use Google Instead", () {
                Navigator.pop(context);
              }),
              _popupOption("Use Facebook Instead", () {
                Navigator.pop(context);
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _popupOption(String text, VoidCallback onTap) {
    final height = MediaQuery.of(context).size.height;
    return ListTile(
      title: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: height * 0.021),
        ),
      ),
      onTap: onTap,
    );
  }
}
