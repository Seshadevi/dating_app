import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import '../model/authstate.dart';
// import '../states/auth_state.dart';



final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// final phoneAuthProvider =
//     StateNotifierProvider<PhoneAuthNotifier, PhoneAuthState>((ref) {
//   return PhoneAuthNotifier();
// });

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});
// Provider to manage whether the code has been sent or not
final codeSentProvider = StateProvider<bool>((ref) => false);
