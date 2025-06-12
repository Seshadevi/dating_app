// providers/google_auth_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn();
});

final authProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final googleSignInControllerProvider = Provider((ref) => GoogleSignInController(
      googleSignIn: ref.read(googleSignInProvider),
      firebaseAuth: ref.read(authProvider),
    ));

class GoogleSignInController {
  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;

  GoogleSignInController({
    required this.googleSignIn,
    required this.firebaseAuth,
  });

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      print('Google sign-in failed: $e');
      return null;
    }
  }
}
