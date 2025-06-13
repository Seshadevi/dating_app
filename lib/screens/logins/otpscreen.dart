import 'dart:async';
import 'package:dating/provider/firebase_auth.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/screens/profile_screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../location_screen.dart';

class OTPScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  const OTPScreen({super.key, required this.phoneNumber});

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
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

  Future<void> verifyOTP(String otp) async {
  final verificationId = ref.read(verificationIdProvider);
  if (verificationId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Verification ID not found.")),
    );
    return;
  }

  try {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    if (userCredential.user != null) {
      final phoneNumber = userCredential.user!.phoneNumber ?? "";
      final statusCode = await ref.read(loginProvider.notifier).sendPhoneNumberAndRoleToAPI(phoneNumber);

      if (statusCode == 200 || statusCode == 201) {
        Navigator.push(context,MaterialPageRoute(builder: (context) => ProfileScreen())); // or your home screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Welcome $phoneNumber!")),
        );
      } else if (statusCode == 400) {
        Navigator.push(context,MaterialPageRoute(builder: (context) => LocationScreen())); // or back to location for signup
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid mobile number. Please try again.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Server error ($statusCode). Please try again later.")),
        );
        // Stay on current screen
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Verification failed: ${e.toString()}")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 10),
              const Text(
                "Verify Your Number",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Enter the code we've sent to ${widget.phoneNumber}",
                style: const TextStyle(fontSize: 18),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: const Text(
                  "Change Number",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              PinCodeTextField(
                appContext: context,
                length: 6,
                controller: otpController,
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8),
                  fieldHeight: 50,
                  fieldWidth: 45,
                  activeColor: const Color(0xFF869E23),
                  selectedColor: const Color(0xFF869E23),
                  inactiveColor: Colors.grey,
                ),
                onChanged: (value) {},
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    "This Code Should Arrive Within ${_start}s",
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      final otp = otpController.text.trim();
                      if (otp.length == 6) {
                        _timer?.cancel();
                        await verifyOTP(otp);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Enter 6-digit OTP")),
                        );
                      }
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.arrow_forward_ios,
                          color: Colors.white, size: 18),
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

  void _showOptionsPopup() {
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
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _popupOption("Send Code Again", () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("New code will be sent again.")));
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
              _popupOption("Use Facebook Instead", () {}),
            ],
          ),
        );
      },
    );
  }

  Widget _popupOption(String text, VoidCallback onTap) {
    return ListTile(
      title: Center(
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      onTap: onTap,
    );
  }
}
