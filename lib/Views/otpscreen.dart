import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../Views/location/location_screen.dart';
import 'package:dating/Viewmodels/otp_view_model.dart';

class OTPScreen extends ConsumerStatefulWidget {
  const OTPScreen({super.key});

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  final TextEditingController otpController = TextEditingController();

  @override
  void dispose() {
    ref.read(otpViewModelProvider.notifier).disposeTimer();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timeLeft = ref.watch(otpViewModelProvider);

    if (timeLeft == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showOptionsPopup(); // Show popup when timer ends
      });
    }

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
              const Text("Verify Your Number",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                "Enter The Code We've Sent By\nText To +918667238534.",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 4),
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
                onChanged: (_) {},
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    "This Code Should Arrive Within ${timeLeft}s",
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      if (otpController.text.length == 6) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LocationScreen()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Please enter the complete OTP")),
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
                otpController.clear();
                ref.read(otpViewModelProvider.notifier).resetTimer();
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
    return Column(
      children: [
        ListTile(
          title: Center(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          onTap: onTap,
        ),
        const Divider(color: Colors.white30, height: 1),
      ],
    );
  }
}
