
import 'dart:convert';
import 'dart:io';

import 'dart:math';
import 'package:dating/model/loginmodel.dart';
import 'package:dating/provider/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dating/utils/dating_apis.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PhoneAuthNotifier extends StateNotifier<UserModel> {
  final Ref ref;
  PhoneAuthNotifier(this.ref) : super(UserModel.initial());


//   Future<bool> tryAutoLogin() async {
//   final prefs = await SharedPreferences.getInstance();

//   // Check if the 'userData' key exists in SharedPreferences
//   if (!prefs.containsKey('userData')) {
//     print('No user data found. tryAutoLogin is set to false.');
//     return false;
//   }

//   try {
//     // Retrieve and decode the user data from SharedPreferences
//     final extractedData = json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
//     print("Extracted data from SharedPreferences: $extractedData");

//     // Validate that all necessary keys exist in the extracted data
//     if (extractedData.containsKey('statusCode') &&
//         extractedData.containsKey('success') &&
//         extractedData.containsKey('messages') &&
//         extractedData.containsKey('data')) {
      
//       // Map the JSON data to the UserModel
//       final userModel = UserModel.fromJson(extractedData);
//       print("User Model from SharedPreferences: $userModel");

//       // Validate nested data structure
//       if (userModel.data != null && userModel.data!.isNotEmpty) {
//         final firstData = userModel.data![0]; // Access the first element in the list
//         if (firstData.user == null || firstData.accessToken == null) {
//           print('Invalid user data structure inside SharedPreferences.');
//           return false;
//         }
//       }

//       // Update the state with the decoded user data
//       state = state.copyWith(
//         statusCode: userModel.statusCode,
//         success: userModel.success,
//         messages: userModel.messages,
//         data: userModel.data,
//       );

//       print('User ID from auto-login: ${state.data?[0].user?.sId}'); // Accessing User ID from the first Data object
//       return true;
//     } else {
//       print('Necessary fields are missing in SharedPreferences.');
//       return false;
//     }
//   } catch (e, stackTrace) {
//     // Log the error for debugging purposes
//     print('Error while parsing user data: $e');
//     print(stackTrace);
//     return false;
//   }
// }

  Future<void> verifyPhoneNumber(
    String phoneNumber,
    WidgetRef ref,
  ) async {
    print('phone number.....$phoneNumber');
    final auth = ref.read(firebaseAuthProvider);
    var loader = ref.read(loadingProvider.notifier);
    var codeSentNotifier = ref.read(codeSentProvider.notifier);
    print(' before try block...........');
    //loader.state = true;
    var pref = await SharedPreferences.getInstance();

    try {
      print('Entering to the try block....');
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('phone verification completed....$phoneNumber');
          // loader.state = false;
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          // loader.state = false;
          print("Verification failed: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          // loader.state = false;
          print("Verification code sent: $verificationId");
          // state = PhoneAuthState(verificationId: verificationId);
          pref.setString("verificationid", verificationId);
          codeSentNotifier.state = true; // Update the codeSentProvider
        },
       

        codeAutoRetrievalTimeout: (String verificationId) {
          // loader.state = false;
          print("Auto-retrieval timeout. Verification ID: $verificationId");
        },
      );
    } catch (e) {
      loader.state = false;
      print("Error during phone verification....: $e");
    }
  }

  Future<void> signInWithPhoneNumber(String smsCode, WidgetRef ref) async {
    final authState = ref.read(firebaseAuthProvider);
    final loadingState = ref.read(loadingProvider.notifier);
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? verificationid = pref.getString('verificationid');

    if (verificationid == null || verificationid.isEmpty) {
      print("No verification ID found.");
      return;
    }

    try {
      loadingState.state = true;
      AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationid,
        smsCode: smsCode,
      );

      UserCredential userCredential =
          await authState.signInWithCredential(credential);

      if (userCredential.user != null) {
        print("Phone verification successful.");

        String? firebaseToken = await userCredential.user?.getIdToken();
        if (firebaseToken != null) {
          await pref.setString('firebaseToken', firebaseToken);
        }

        await sendPhoneNumberAndRoleToAPI(
          phoneNumber: userCredential.user!.phoneNumber!,
        );

      //   await ref.read(loginProvider.notifier).tryAutoLogin();
      // }
    } catch (e) {
      print("Error during phone verification: $e");
    } finally {
      loadingState.state = false;
    }
  }

  Future<void> sendPhoneNumberAndRoleToAPI({
    required String phoneNumber,
  }) async {
    const String apiUrl = Dgapi.login;
    final prefs = await SharedPreferences.getInstance();
    print('Phone number: $phoneNumber');

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer YOUR_API_TOKEN",
        },
        body: json.encode({
          "mobile": phoneNumber.toString(),
        }),
      );

      print("Raw API Response: ${response.body}"); // Debugging

      if (response.statusCode >= 200 && response.statusCode < 300) {
        var userDetails = json.decode(response.body);

        if (userDetails != null &&
            userDetails['data'] != null &&
            userDetails['data'].isNotEmpty) {
          // UserModel user = UserModel.fromJson(userDetails);
          // state = user;

          // print('login model...${state.data![0].accessToken}');
          // print("User Data to Save: ${user.toJson()}");

          // final userData = json.encode({
          //   'statusCode': user.statusCode ?? 0,
          //   'success': user.success,
          //   'messages': user.messages,
          //   'data': user.data?.map((data) => data.toJson()).toList(),
          // });

          // print("User Data to Save in SharedPreferences: $userData");

          // try {
          //   await prefs.setString('userData', userData);
          // } catch (e) {
          //   print("Error saving user data: $e");
          // }
        } else {
          print('Error: API response does not contain valid data');
        }
      } else {
        print(
            "Failed to send data to the API. Status code: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (e) {
      print("Error while sending data to the API: $e");
    }
  }
  }
  Future<String> restoreAccessToken() async {
    
    const url = Dgapi.refreshToken; 

    final prefs = await SharedPreferences.getInstance();

    try {
        // Retrieve stored user data
    // ✅ Prefer getting from loginProvider instead of SharedPreferences
        final currentUser = ref.read(loginProvider);
        final currentRefreshToken = currentUser.data?.first.refreshToken;
        final currentAccesstoken =currentUser.data?.first.accessToken;

        if (currentRefreshToken == null || currentRefreshToken.isEmpty) {
          throw Exception("No valid refresh token found.");
        }

        print("Using refresh token: $currentRefreshToken");
        print("using current accesstoken: $currentAccesstoken");

        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer $currentRefreshToken',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode({"refresh_token": currentRefreshToken}),
        );


      var userDetails = json.decode(response.body);
      print('restore token response $userDetails');
      switch (response.statusCode) {
        case 401:
          // Handle 401 Unauthorized
          // await logout();
          // await tryAutoLogin();
          print("shared preferance ${prefs.getString('userTokens')}");
      
          break;
       // loading(false); // Update loading state
        case 200:
          print("Refresh access token success");

          // Extract the new access token and refresh token
          final newAccessToken = userDetails['data']['access_token'];
          final newRefreshToken = userDetails['data']['refresh_token'];

          print('New access token: $newAccessToken');
          print('New refresh token: $newRefreshToken');

          // Retrieve existing user data from SharedPreferences
          String? storedUserData = prefs.getString('userData');

          if (storedUserData != null) {
            // Parse the stored user data into a UserModel object
            // UserModel user = UserModel.fromJson(json.decode(storedUserData));

            // // Update the accessToken and refreshToken in the existing data model
            // user = user.copyWith(
            //   data: [
            //     user.data![0].copyWith(
            //       accessToken: newAccessToken,
            //       refreshToken: newRefreshToken,
            //     ),
            //   ],
            // );
            //     // Convert the updated UserModel back to JSON
            // final updatedUserData = json.encode({
            //   'statusCode': user.statusCode,
            //   'success': user.success,
            //   'messages': user.messages,
            //   'data': user.data?.map((data) => data.toJson()).toList(),
            // });

            // // Debug: Print updated user data before saving
            // print("Updated User Data to Save in SharedPreferences: $updatedUserData");

            // // Save the updated user data in SharedPreferences
            // await prefs.setString('userData', updatedUserData);

            // // Debug: Print user data after saving
            // print("User Data saved in SharedPreferences: ${prefs.getString('userData')}");
            // print("updated accesstoken ${user.data![0].accessToken}");
 
            // // ✅ Update the provider state globally
            // ref.read(loginProvider.notifier).state = user;
            // return newAccessToken; // Return the new access token
          } else {

            // Handle the case where there is no existing user data in SharedPreferences
            print("No user data found in SharedPreferences.");
          }

        // loading(false); // Update loading state
       }
    } on FormatException catch (formatException) {
      print('Format Exception: ${formatException.message}');
      print('Invalid response format.');
    } on HttpException catch (httpException) {
      print('HTTP Exception: ${httpException.message}');
    } catch (e) {
      print('General Exception: ${e.toString()}');
      if (e is Error) {
        print('Stack Trace: ${e.stackTrace}');
      }
    }
    return ''; // Return null in case of any error
 }

}



final loginProvider =StateNotifierProvider<PhoneAuthNotifier, UserModel>((ref) {
       return PhoneAuthNotifier(ref);
});