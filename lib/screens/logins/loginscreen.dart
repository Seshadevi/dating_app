import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/provider/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:dating/screens/logins/otpscreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dating/provider/loginProvider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late String phoneNumber = '';
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Hide keyboard on outside tap
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 25),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Please Enter Your Number",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Phone number used for verification.",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 25),
                    IntlPhoneField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      initialCountryCode: 'IN',
                      onChanged: (phone) {
                        phoneNumber = phone.completeNumber;
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Icon(Icons.lock_outline, size: 16),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              "We Never Share This With Anyone And It Won't Be On Your Profile.",
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  
                  onTap: () async{
                   
                    // FocusScope.of(context).unfocus(); // ✅ Hide keyboard before showing dialog
                    if (phoneNumber.isNotEmpty) {
                      // Future.delayed(const Duration(milliseconds: 100), () {
                      //   showDialog(
                      //     context: context,
                      //     builder: (_) => _buildVerifyDialog(context, phoneNumber),

                      //   );
                      // });
                      // Show loading dialog
                      showDialog(
                        context: context,
                        barrierDismissible: false, // prevent closing by tapping outside
                        builder: (context) {
                          return const Center(
                            child: CircularProgressIndicator(
                               valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD68F95)), // 💖 QPID color
                            ),
                          );
                        },
                      );
                      final result = await ref.read(loginProvider.notifier).verifyPhoneNumber(phoneNumber, ref);
                
                  if (result['success'] == true) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OTPScreen(phoneNumber: phoneNumber),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result['message'] ?? "Failed to send OTP."),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                      
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [DatingColors.lightpinks, 
                        DatingColors.everqpidColor
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerifyDialog(BuildContext context, String number) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFB6E11D), Color(0xFF2B2B2B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Please confirm number\n",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "$number",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Edit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                  //   final FocusNode phoneFocusNode = FocusNode();

                  //  phoneFocusNode.unfocus(); // force close
                  //   await Future.delayed(const Duration(milliseconds: 1)); // slight delay
                  Navigator.pop(context); // Close popup regardless

                  final result = await ref.read(loginProvider.notifier).verifyPhoneNumber(phoneNumber, ref);
                
                  if (result['success'] == true) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OTPScreen(phoneNumber: phoneNumber),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result['message'] ?? "Failed to send OTP."),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }

                  },
                  child: const Text(
                    "Confirm",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
