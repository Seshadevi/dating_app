
import 'package:dating/model/signupprocessmodels/drinkingModel.dart';
import 'package:dating/provider/loader.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/utils/dating_apis.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class DrinkingNotifier extends StateNotifier<DrinkingModel> {
  final Ref ref;
  DrinkingNotifier(this.ref) : super(DrinkingModel.initial());
  
  Future<void> getdrinking() async {
    final loadingState = ref.read(loadingProvider.notifier);
    try {
      loadingState.state = true;
      // Retrieve the token from SharedPreferences
      print('get drinking');

      
    // ✅ Get token directly from loginProvider model
    final currentUser = ref.read(loginProvider);
    final token = currentUser.data?.first.accessToken;

    if (token == null || token.isEmpty) {
      throw Exception("Access token is missing. Please log in again.");
    }
    
      print('Retrieved Token from drinking: $token');
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
        Uri.parse(Dgapi.drinking),
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      final responseBody = response.body;
      print('Get modes Status Code: ${response.statusCode}');
      print('Get modes Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = DrinkingModel.fromJson(res);
          state = usersData;
          print("drinking fetched successfully: ${usersData.message}");
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing driking.");
        }
      } else {
        print("Error fetching drinking: ${response.body}");
        throw Exception("Error fetching drinking: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch drinking: $e");
    }
  }
}

final drinkingProvider = StateNotifierProvider<DrinkingNotifier, DrinkingModel>((ref) {
  return DrinkingNotifier(ref);
});