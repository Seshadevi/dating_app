import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart'; // for MediaType

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

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if the 'userData' key exists in SharedPreferences
    if (!prefs.containsKey('userData')) {
      print('No user data found. tryAutoLogin is set to false.');
      return false;
    }

    try {
      // Retrieve and decode the user data from SharedPreferences
      final extractedData =
          json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
      print("Extracted data from SharedPreferences: $extractedData");

      // Validate that all necessary keys exist in the extracted data
      if (extractedData.containsKey('statusCode') &&
          extractedData.containsKey('success') &&
          extractedData.containsKey('messages') &&
          extractedData.containsKey('data')) {
        // Map the JSON data to the UserModel
        final userModel = UserModel.fromJson(extractedData);
        print("User Model from SharedPreferences: $userModel");

        // Validate nested data structure
        if (userModel.data != null && userModel.data!.isNotEmpty) {
          final firstData =
              userModel.data![0]; // Access the first element in the list
          if (firstData.user == null || firstData.accessToken == null) {
            print('Invalid user data structure inside SharedPreferences.');
            return false;
          }
        }

        // Update the state with the decoded user data
        state = state.copyWith(
          statusCode: userModel.statusCode,
          success: userModel.success,
          messages: userModel.messages,
          data: userModel.data,
        );

        print(
            'User ID from auto-login: ${state.data?[0].user?.id}'); // Accessing User ID from the first Data object
        return true;
      } else {
        print('Necessary fields are missing in SharedPreferences.');
        return false;
      }
    } catch (e, stackTrace) {
      // Log the error for debugging purposes
      print('Error while parsing user data: $e');
      print(stackTrace);
      return false;
    }
  }

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

  // Future<void> signInWithPhoneNumber(String smsCode, WidgetRef ref) async {
  //   final auth = ref.read(firebaseAuthProvider);
  //   final loader = ref.read(loadingProvider.notifier);
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   String? verificationid = pref.getString('verificationid');

  //   if (verificationid == null || verificationid.isEmpty) {
  //     print("No verification ID found.");
  //     return;
  //   }

  //   try {
  //     loader.state = true;
  //     AuthCredential credential = PhoneAuthProvider.credential(
  //       verificationId: verificationid,
  //       smsCode: smsCode,
  //     );

  //     UserCredential userCredential =
  //         await auth.signInWithCredential(credential);

  //     if (userCredential.user != null) {
  //       print("Phone verification successful.");
  //       String? firebaseToken = await userCredential.user?.getIdToken();
  //       if (firebaseToken != null) {
  //         await pref.setString('firebaseToken', firebaseToken);
  //       }

  //       await sendPhoneNumberAndRoleToAPI(
  //         phoneNumber: userCredential.user!.phoneNumber!,
  //       );

  //       await ref.read(loginProvider.notifier).tryAutoLogin();
  //     } else {
  //       print("UserCredential is null.");
  //     }
  //   } catch (e) {
  //     print("Error during sign-in with phone: $e");
  //   } finally {
  //     loader.state = false;
  //   }
  // }

  Future<int> sendPhoneNumberAndRoleToAPI(String phoneNumber) async {
    const String apiUrl = Dgapi.userExisting;
    final prefs = await SharedPreferences.getInstance();
    print('Sending phone number to API: $phoneNumber');

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"mobile": phoneNumber}),
      );

      print("API Response: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final userDetails = json.decode(response.body);
        if (userDetails != null && userDetails['data'] != null) {
          final userModel = UserModel.fromJson(userDetails);
          state = userModel;
          print('user model data.......$userDetails');

          final userData = json.encode(userDetails);
          await prefs.setString('userData', userData);
          print('User data saved in SharedPreferences.');
          return response.statusCode; // success
        } else {
          return 400; // invalid/missing data
        }
      } else {
        print("API Error: ${response.statusCode}");
        return response.statusCode; // forward status for handling
      }
    } catch (e) {
      print("Exception during API call: $e");
      return 500; // server or network error
    }
  }

  Future<int> sendemailToAPI(String email) async {
    const String apiUrl = Dgapi.userExisting;
    final prefs = await SharedPreferences.getInstance();
    print('Sending email to API: $email');

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode({"email": email}),
        headers: {'Content-Type': 'application/json'},
      );

      print("API Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final userDetails = json.decode(response.body);
        if (userDetails != null && userDetails['data'] != null) {
          final userModel = UserModel.fromJson(userDetails);
          state = userModel;

          final userData = json.encode(userDetails);
          await prefs.setString('userData', userData);

          return response.statusCode; // 200 or 201
        } else {
          return 400; // malformed data, treat like bad request
        }
      } else {
        return response.statusCode; // 400 or 500 etc.
      }
    } catch (e) {
      print("Exception: $e");
      return 500; // fallback for exception
    }
  }

  Future<int> signupuserApi({
    required String email,
    required String mobile,
    required double latitude,
    required double longitude,
    required String userName,
    required String dateOfBirth,
    required String selectedGender,
    required bool showGenderOnProfile,
    required int? modeid,
    required String? modename,
    required List<String> selectedGenderIds,
    required List<int> selectionOptionIds,
    required int selectedHeight,
    required List<int> selectedInterestIds,
    required List<int> selectedqualitiesIDs,
    required List<int> selectedhabbits,
    required List<int> selectedkids,
    required List<int> selectedreligions,
    required List<int> selectedcauses,
    required Map<int, String> seletedprompts,
    required List<File?> choosedimages,
    required List<int> defaultmessages,
    required String? finalheadline,
    required bool termsAndCondition,
  }) async {
    const String apiUrl = Dgapi.login;
    final prefs = await SharedPreferences.getInstance();

    print("✅ Proceeding with API request...");
    print(
        'sign in data.........email:$email,mobile:$mobile,latitude:$latitude,longitude:$longitude,Name:$userName,dob:$dateOfBirth,selectedgender:$selectedGender:');
    print(
        'data.......show:$showGenderOnProfile,height:$selectedHeight,headline:$finalheadline,images:${choosedimages.length},');

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Basic fields
      request.fields['email'] = email;
      request.fields['latitude'] = latitude.toString();
      request.fields['longitude'] = longitude.toString();
      request.fields['firstName'] = userName;
      request.fields['dob'] = dateOfBirth;
      request.fields['role'] = "user";
      request.fields['gender'] = selectedGender;
      request.fields['showOnProfile'] = showGenderOnProfile.toString();
      request.fields['mode'] = modename ?? '';
      request.fields['height'] = selectedHeight.toString();
      request.fields['headLine'] = finalheadline ?? '';
      request.fields['termsAndConditions'] = termsAndCondition.toString();
      request.fields['mobile'] = mobile;

      // // Safe list fields (skip empty ones)
      if (selectedGenderIds.isNotEmpty) {
        for (int i = 0; i < selectedGenderIds.length; i++) {
          request.fields['genderIdentities[$i]'] = selectedGenderIds[i];
        }
      }

      if (selectionOptionIds.isNotEmpty) {
        // With this loop
        for (int i = 0; i < selectionOptionIds.length; i++) {
          request.fields['lookingFor[$i]'] = selectionOptionIds[i].toString();
        }
      }

      if (selectedInterestIds.isNotEmpty) {
        for (int i = 0; i < selectedInterestIds.length; i++) {
          request.fields['interests[$i]'] = selectedInterestIds[i].toString();
        }
      }

      if (selectedqualitiesIDs.isNotEmpty) {
        for (int i = 0; i < selectedqualitiesIDs.length; i++) {
          request.fields['qualities[$i]'] = selectedqualitiesIDs[i].toString();
        }
      }

      if (selectedhabbits.isNotEmpty) {
        for (int i = 0; i < selectedhabbits.length; i++) {
          request.fields['drinking[$i]'] = selectedhabbits[i].toString();
        }
      }

      if (selectedkids.isNotEmpty) {
        for (int i = 0; i < selectedkids.length; i++) {
          request.fields['kids[$i]'] = selectedkids[i].toString();
        }
      }

      if (selectedreligions.isNotEmpty) {
        for (int i = 0; i < selectedreligions.length; i++) {
          request.fields['religions[$i]'] = selectedreligions[i].toString();
        }
      }

      if (selectedcauses.isNotEmpty) {
        for (int i = 0; i < selectedcauses.length; i++) {
          request.fields['causesAndCommunities[$i]'] =
              selectedcauses[i].toString();
        }
      }

      if (seletedprompts.isNotEmpty) {
        // Prompts (Map<int, String>)
        seletedprompts.forEach((key, value) {
          request.fields['prompts[$key]'] = value;
        });
      }

      if (defaultmessages.isNotEmpty) {
        for (int i = 0; i < defaultmessages.length; i++) {
          request.fields['defaultMessages[$i]'] = defaultmessages[i].toString();
        }
      }

      // Upload images (only jpg/png/jpeg)
      for (int i = 0; i < choosedimages.length; i++) {
        final image = choosedimages[i];

        if (image != null && await image.exists()) {
          final filePath = image.path;
          final fileExtension = filePath.split('.').last.toLowerCase();

          MediaType? contentType;
          if (fileExtension == 'jpg' || fileExtension == 'jpeg') {
            contentType = MediaType('image', 'jpeg');
          } else if (fileExtension == 'png') {
            contentType = MediaType('image', 'png');
          } else {
            print('❌ Unsupported file type: $filePath');
            continue;
          }

          final multipartFile = await http.MultipartFile.fromPath(
            'profilePic',
            filePath,
            contentType: contentType,
          );

          request.files.add(multipartFile);
        }
      }

      // Send the request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print("🔄 API Response: $responseBody");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        await prefs.setBool("isSignedUp", true);
        final userDetails = jsonDecode(responseBody);
        final userModel = UserModel.fromJson(userDetails);
        state = userModel;

        final userData = json.encode(userDetails);
        await prefs.setString('userData', userData);
        print('User data saved in SharedPreferences.');
        return response.statusCode;
      } else {
        print("❌ Signup failed with status: ${response.statusCode}");
        return response.statusCode;
      }
    } catch (e) {
      print("❗ Exception during signup: $e");
      return 500;
    }
  }

  Future<int> updateProfile({
    int? modeid,
    String? modename,
    List<int>? causeId,
    String? bio,
    List<int>? interestId,
    List<int>? qualityId,
    String? prompt,
    File? image,
  }) async {
    
    print('updated data....modeId:$modeid, modename:$modename, causedId:$causeId, intrestId:$interestId, qualityId:$qualityId, bio:$bio, prompt:$prompt, image:${image?.path}');

    try {
      final userid = state.data![0].user?.id
;
    final String apiUrl = "${Dgapi.updateprofile}/$userid";
      final prefs = await SharedPreferences.getInstance();
      String? userDataString = prefs.getString('userData');

      if (userDataString == null || userDataString.isEmpty) {
        throw Exception("User token is missing. Please log in again.");
      }

      final Map<String, dynamic> userData = jsonDecode(userDataString);
      String? token = userData['accessToken'];

      // Fallback if accessToken is nested inside data[]
      if (token == null || token.isEmpty) {
        token = userData['data'] != null &&
                (userData['data'] as List).isNotEmpty &&
                userData['data'][0]['access_token'] != null
            ? userData['data'][0]['access_token']
            : null;
      }

      if (token == null || token.isEmpty) {
        throw Exception("User token is invalid. Please log in again.");
      }

      print('✅ Retrieved Token: $token');

      var request = http.MultipartRequest('PUT', Uri.parse(apiUrl));

      // ⬅️ Add Authorization header here
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      if (modename != null) request.fields[''] = modename;
      if (modeid != null) request.fields[''] = modeid.toString();
      if (causeId != null) request.fields[''] = causeId.toString();
      if (qualityId != null) request.fields[''] = qualityId.toString();
      if (interestId != null) request.fields[''] = interestId.toString();
      if (bio != null) request.fields[''] = bio;
      if (prompt != null) request.fields[''] = prompt;
      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath('', image.path));
      }
      // if (qualityId != null) {
      //   for (var id in qualityId) {
      //     request.fields[''] = id.toString(); // or 'quality_id[index]' based on backend
      //   }
      // }
      

      // Send request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print("📨 API Response: $responseBody");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final userDetails = jsonDecode(responseBody);
        print("✅ Updated data: $userDetails");
        return response.statusCode;
      } else {
        print("❌ Update failed with status: ${response.statusCode}");
        return response.statusCode;
      }
    } catch (e) {
      print("❗ Exception during profile update: $e");
      return 500;
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
