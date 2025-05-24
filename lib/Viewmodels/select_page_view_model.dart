import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Views/login_screen.dart';

final selectPageViewModelProvider =
    Provider<SelectPageViewModel>((ref) => SelectPageViewModel());

class SelectPageViewModel {
  void onGoogleLogin() {
    debugPrint("Google Login Clicked");
    // Handle Google login logic here
  }

  void onFacebookLogin() {
    debugPrint("Facebook Login Clicked");
    // Handle Facebook login logic here
  }

  void onMobileLogin(BuildContext context) {
    debugPrint("Mobile Login Clicked");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}
