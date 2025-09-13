import 'dart:convert';
import 'package:dating/provider/loader.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/utils/dating_apis.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostSnoozeProvider extends StateNotifier<bool> {
  final Ref ref;
  PostSnoozeProvider(this.ref) : super(false); // default snooze OFF

  Future<void> toggleSnooze(bool isOn) async {
    final loadingState = ref.read(loadingProvider.notifier);
    final prefs = await SharedPreferences.getInstance();

    try {
      loadingState.state = true;

      // 🔹 Retrieve token
      String? userDataString = prefs.getString('userData');
      if (userDataString == null || userDataString.isEmpty) {
        throw Exception("User token is missing. Please log in again.");
      }

      final Map<String, dynamic> userData = jsonDecode(userDataString);

      String? token = userData['accessToken'] ??
          (userData['data'] != null &&
                  (userData['data'] as List).isNotEmpty &&
                  userData['data'][0]['access_token'] != null
              ? userData['data'][0]['access_token']
              : null);

      if (token == null || token.isEmpty) {
        throw Exception("User token is invalid. Please log in again.");
      }

      print('Retrieved Token: $token');

      // 🔹 Setup retry client
      final client = RetryClient(
        http.Client(),
        retries: 3,
        when: (response) =>
            response.statusCode == 401 || response.statusCode == 400,
        onRetry: (req, res, retryCount) async {
          if (retryCount == 0 &&
              (res?.statusCode == 401 || res?.statusCode == 400)) {
            print("Token expired, refreshing...");
            String? newAccessToken =
                await ref.read(loginProvider.notifier).restoreAccessToken();

            await prefs.setString('accessToken', newAccessToken ?? "");
            token = newAccessToken;
            req.headers['Authorization'] = 'Bearer $newAccessToken';

            print("New Token: $newAccessToken");
          }
        },
      );

      print('Calling Snooze API with POST...');

      final response = await client.post(
        Uri.parse(Dgapi.postsnooze),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "snooz": isOn ? 1 : 0,
        }),
      );

      print('POST Snooze Status Code: ${response.statusCode}');
      print('POST Snooze Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        state = isOn; // ✅ Update state only to bool
        print('Snooze updated successfully: $isOn');
      } else {
        throw Exception("Error updating snooze: ${response.body}");
      }
    } catch (e) {
      print("Failed to update snooze: $e");
      rethrow;
    } finally {
      loadingState.state = false;
    }
  }

}

final postSnoozeProvider =
    StateNotifierProvider<PostSnoozeProvider, bool>((ref) {
  return PostSnoozeProvider(ref);
});







class PostIncogintoeProvider extends StateNotifier<bool> {
  final Ref ref;
  PostIncogintoeProvider(this.ref) : super(false); // default snooze OFF

  Future<void> toggleIncognito(bool isOn) async {
    final loadingState = ref.read(loadingProvider.notifier);
    final prefs = await SharedPreferences.getInstance();

    try {
      loadingState.state = true;

      // 🔹 Retrieve token
      String? userDataString = prefs.getString('userData');
      if (userDataString == null || userDataString.isEmpty) {
        throw Exception("User token is missing. Please log in again.");
      }

      final Map<String, dynamic> userData = jsonDecode(userDataString);

      String? token = userData['accessToken'] ??
          (userData['data'] != null &&
                  (userData['data'] as List).isNotEmpty &&
                  userData['data'][0]['access_token'] != null
              ? userData['data'][0]['access_token']
              : null);

      if (token == null || token.isEmpty) {
        throw Exception("User token is invalid. Please log in again.");
      }

      print('Retrieved Token: $token');

      // 🔹 Setup retry client
      final client = RetryClient(
        http.Client(),
        retries: 3,
        when: (response) =>
            response.statusCode == 401 || response.statusCode == 400,
        onRetry: (req, res, retryCount) async {
          if (retryCount == 0 &&
              (res?.statusCode == 401 || res?.statusCode == 400)) {
            print("Token expired, refreshing...");
            String? newAccessToken =
                await ref.read(loginProvider.notifier).restoreAccessToken();

            await prefs.setString('accessToken', newAccessToken ?? "");
            token = newAccessToken;
            req.headers['Authorization'] = 'Bearer $newAccessToken';

            print("New Token: $newAccessToken");
          }
        },
      );

      print('Calling Incognito API with POST...');

      final response = await client.post(
        Uri.parse(Dgapi.postsnooze),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "incognito": isOn ? 1 : 0,
        }),
      );

      print('POST Incognito Status Code: ${response.statusCode}');
      print('POST Incognito Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        state = isOn; // ✅ Update state only to bool
        print('Incognito updated successfully: $isOn');
      } else {
        throw Exception("Error updating Incognito: ${response.body}");
      }
    } catch (e) {
      print("Failed to update Incognito: $e");
      rethrow;
    } finally {
      loadingState.state = false;
    }
  }

}
  final postIncogintoeProvider =
    StateNotifierProvider<PostIncogintoeProvider, bool>((ref) {
  return PostIncogintoeProvider(ref);
});