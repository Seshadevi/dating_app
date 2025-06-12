import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dating/model/loginmodel.dart';
import 'package:dating/provider/firebase_auth.dart';
import 'package:dating/provider/loader.dart';
import 'package:dating/utils/dating_apis.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PhoneAuthNotifier extends StateNotifier<UserModel> {
  final Ref ref;
  PhoneAuthNotifier(this.ref) : super(UserModel.initial());

  Future<bool> verifyPhoneNumber(String phoneNumber, WidgetRef ref) async {
    print('Phone number: $phoneNumber');
    final auth = ref.read(firebaseAuthProvider);
    var loader = ref.read(loadingProvider.notifier);
    var codeSentNotifier = ref.read(codeSentProvider.notifier);
    var pref = await SharedPreferences.getInstance();
       // Use a Completer to handle the async callbacks
  Completer<bool> completer = Completer<bool>();
    try {
      print('Starting phone verification...');
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        
        verificationCompleted: (PhoneAuthCredential credential) async {
          
          print('Verification completed automatically.');
          await auth.signInWithCredential(credential);
           if (!completer.isCompleted) {
          completer.complete(true);
        }
        },
        verificationFailed: (FirebaseAuthException e) {
          
          print("Verification failed: ${e.message}");
            if (!completer.isCompleted) {
          completer.complete(false);
        }
        },
        codeSent: (String verificationId, int? resendToken) {
          print("Code sent. Verification ID: $verificationId");
          pref.setString("verificationid", verificationId);
          ref.read(verificationIdProvider.notifier).state = verificationId;
          //codeSentNotifier.state = true;
           if (!completer.isCompleted) {
          completer.complete(true);
        }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("Auto-retrieval timeout. Verification ID: $verificationId");
        },
      );
      return await completer.future;
    } catch (e) {
      loader.state = false;
      print("Error during phone verification: $e");
      if (!completer.isCompleted) {
      completer.complete(false);
    }
    return false;
    }
  }

  Future<void> signInWithPhoneNumber(String smsCode, WidgetRef ref) async {
    final auth = ref.read(firebaseAuthProvider);
    final loader = ref.read(loadingProvider.notifier);
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? verificationid = pref.getString('verificationid');

    if (verificationid == null || verificationid.isEmpty) {
      print("No verification ID found.");
      return;
    }

    try {
      loader.state = true;
      AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationid,
        smsCode: smsCode,
      );

      UserCredential userCredential =
          await auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        print("Phone verification successful.");
        String? firebaseToken = await userCredential.user?.getIdToken();
        if (firebaseToken != null) {
          await pref.setString('firebaseToken', firebaseToken);
        }

        await sendPhoneNumberAndRoleToAPI(
          phoneNumber: userCredential.user!.phoneNumber!,
        );

        await ref.read(loginProvider.notifier).tryAutoLogin();
      } else {
        print("UserCredential is null.");
      }
    } catch (e) {
      print("Error during sign-in with phone: $e");
    } finally {
      loader.state = false;
    }
  }

  Future<void> sendPhoneNumberAndRoleToAPI({
    required String phoneNumber,
  }) async {
    const String apiUrl = Dgapi.login;
    final prefs = await SharedPreferences.getInstance();
    print('Sending phone number to API: $phoneNumber');

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          // Replace this with actual token retrieval logic if needed
          "Authorization": "Bearer ${prefs.getString('firebaseToken') ?? ''}",
        },
        body: json.encode({"mobile": phoneNumber}),
      );

      print("API Response: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        var userDetails = json.decode(response.body);
        if (userDetails != null && userDetails['data'] != null) {
          final userModel = UserModel.fromJson(userDetails);
          state = userModel;

          final userData = json.encode(userDetails);
          await prefs.setString('userData', userData);

          print('User data saved in SharedPreferences.');
        } else {
          print("API response missing expected data.");
        }
      } else {
        print("API Error: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (e) {
      print("Exception during API call: $e");
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('userData')) {
      print('No user data found in SharedPreferences.');
      return false;
    }

    try {
      final extractedData =
          json.decode(prefs.getString('userData')!) as Map<String, dynamic>;

      final userModel = UserModel.fromJson(extractedData);

      if (userModel.data != null && userModel.data!.isNotEmpty) {
        state = userModel;
       // print('Auto-login successful for user: ${state.data![0].user?.sId}');
        return true;
      } else {
        print("Invalid user data structure.");
        return false;
      }
    } catch (e) {
      print('Error parsing user data: $e');
      return false;
    }
  }

  Future<String> restoreAccessToken() async {
    const url = Dgapi.refreshToken;
    final prefs = await SharedPreferences.getInstance();

    try {
      final currentUser = ref.read(loginProvider);
      final currentRefreshToken = currentUser.data?.first.refreshToken;

      if (currentRefreshToken == null || currentRefreshToken.isEmpty) {
        throw Exception("No valid refresh token found.");
      }

      print("Using refresh token: $currentRefreshToken");

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $currentRefreshToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({"refresh_token": currentRefreshToken}),
      );

      final userDetails = json.decode(response.body);
      print('Token refresh response: $userDetails');

      if (response.statusCode == 200) {
        final newAccessToken = userDetails['data']['access_token'];
        final newRefreshToken = userDetails['data']['refresh_token'];

        print('New access token: $newAccessToken');
        print('New refresh token: $newRefreshToken');

        // You can update the UserModel here if needed
        return newAccessToken;
      } else {
        print("Failed to refresh token. Status: ${response.statusCode}");
      }
    } catch (e) {
      print('Exception while refreshing token: $e');
    }

    return '';
  }
}

final loginProvider =
    StateNotifierProvider<PhoneAuthNotifier, UserModel>((ref) {
  return PhoneAuthNotifier(ref);
});
