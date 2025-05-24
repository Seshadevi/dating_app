import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dating/Viewmodels/select_page_view_model.dart';
import 'package:dating/screens/logins/loginscreen.dart';


class SelectPage extends ConsumerWidget {
  const SelectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(selectPageViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildImageSection(),
          const Spacer(),
          _buildButtons(context, viewModel),
          const SizedBox(height: 20),
          _buildDisclaimerText(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      width: double.infinity,
      height: 450,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF869E23), Color(0xFF000000)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(60),
          bottomRight: Radius.circular(60),
        ),
      ),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            "assets/image.png",
            width: 290,
            height: 290,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context, SelectPageViewModel viewModel) {
    return Column(
      children: [
        _longButton(
          "Continue With Google",
          Icons.account_circle,
          viewModel.onGoogleLogin,
        ),
        const SizedBox(height: 10),
        _longButton(
          "Continue With Facebook",
          Icons.facebook,
          viewModel.onFacebookLogin,
        ),
        const SizedBox(height: 10),
        _longButton(
          "Use Mobile Number",
          Icons.mobile_friendly,
          () => viewModel.onMobileLogin(context),
        ),
      ],
    );
  }

  Widget _longButton(String text, IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: const BorderSide(color: Colors.grey, width: 1.5),
          ),
        ),
        icon: Icon(icon, size: 30),
        label: Text(text, style: const TextStyle(fontSize: 14)),
      ),
    );
  }

  Widget _buildDisclaimerText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        "By Signing Up, You Agree To Our Terms. See How We Use Your Data In Our Privacy Policy.",
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 15,
          color: Color.fromARGB(179, 29, 28, 28),
        ),
      ),
    );
  }
}
