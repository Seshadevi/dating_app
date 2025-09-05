import 'dart:async';
import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/firebase_auth.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/screens/profile_screens/profile_bottomNavigationbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  const OTPScreen({super.key, required this.phoneNumber});

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  TextEditingController otpController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int _start = 59;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
    _focusNode.dispose();
    super.dispose();
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
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => CustomBottomNavigationBar()),
            (route) => false,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Welcome $phoneNumber!")),
          );
        } else if (statusCode == 404) {
          Navigator.pushNamed(
            context,
            '/locationScreen',
            arguments: {'mobile': phoneNumber},
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("user not found,please signup.")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Server error ($statusCode). Please try again later.")),
          );
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
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(), // hide keyboard on outside tap
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
                  "Enter the code we've sent to",
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),
                Text(
                  " ${widget.phoneNumber}",
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
                  focusNode: _focusNode,
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
                  onCompleted: (value) {
                    // Close the keyboard automatically when 6 digits entered
                    FocusScope.of(context).unfocus();
                  },
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
                          color: DatingColors.black,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.arrow_forward_ios,
                            color: DatingColors.darkGrey, size: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
              colors: [DatingColors.lightpinks, DatingColors.everqpidColor],
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
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("New code will be sent again.")));
              }),
              _popupOption("Change Number", () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => OTPScreen(phoneNumber: widget.phoneNumber)),
                );
              }),
              _popupOption("Use Google Instead", () {
                Navigator.pushNamed(context, '/joinscreen');
              }),
              _popupOption("Use Facebook Instead", () {
                Navigator.pushNamed(context, '/joinscreen');
              }),
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
