
import 'package:dating/model/signupprocessmodels/defaultMessagesModel.dart';
import 'package:dating/provider/loader.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/utils/dating_apis.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class DefaultNotifier extends StateNotifier<DefaultModel> {
  final Ref ref;
  DefaultNotifier(this.ref) : super(DefaultModel.initial());
  
  Future<void> getdefaultmessages() async {
    final loadingState = ref.read(loadingProvider.notifier);
    try {
      loadingState.state = true;
      // Retrieve the token from SharedPreferences
      print('get default messages');

      
    // ✅ Get token directly from loginProvider model
    final currentUser = ref.read(loginProvider);
    final token = currentUser.data?.first.accessToken;

    if (token == null || token.isEmpty) {
      throw Exception("Access token is missing. Please log in again.");
    }
    
      print('Retrieved Token from defaultmessages: $token');
      // Initialize RetryClient for handling retries
      final client = RetryClient(
        http.Client(),
        retries: 3, // Retry up to 3 times
        when: (response) =>
            response.statusCode == 401 || response.statusCode == 400,
        onRetry: (req, res, retryCount) async {
          if (retryCount == 0 &&
              (res?.statusCode == 401 || res?.statusCode == 400)) {
            String? newAccessToken =
                await ref.read(loginProvider.notifier).restoreAccessToken();
              if (newAccessToken != null && newAccessToken.isNotEmpty) {
                req.headers['Authorization'] = 'Bearer $newAccessToken';
                print("New token applied: $newAccessToken");
              } else {
                print("Failed to retrieve new access token.");
              }
          }
        },
      );
      final response = await client.get(
        Uri.parse(Dgapi.defaultMessages),
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      final responseBody = response.body;
      print('Get default Status Code: ${response.statusCode}');
      print('Get default Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = DefaultModel.fromJson(res);
          state = usersData;
          print("default fetched successfully: ${usersData.message}");
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing default.");
        }
      } else {
        print("Error fetching defaultmessages: ${response.body}");
        throw Exception("Error fetching defaultmessages: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch defaultmessages: $e");
    }
  }
}

final defaultmessagesProvider = StateNotifierProvider<DefaultNotifier, DefaultModel>((ref) {
  return DefaultNotifier(ref);
});