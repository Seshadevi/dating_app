
import 'package:dating/model/signupprocessmodels/termConditionalModel.dart';
import 'package:dating/provider/loader.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/utils/dating_apis.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class TermsNotifier extends StateNotifier<TermsAndConditions> {
  final Ref ref;
  TermsNotifier(this.ref) : super(TermsAndConditions.initial());
  
  Future<void> getTermsandConditions() async {
    final loadingState = ref.read(loadingProvider.notifier);
    try {
      loadingState.state = true;
      // Retrieve the token from SharedPreferences
      print('get TermsAndConditions');

      
    // ✅ Get token directly from loginProvider model
    final currentUser = ref.read(loginProvider);
    final token = currentUser.data?.first.accessToken;

    if (token == null || token.isEmpty) {
      throw Exception("Access token is missing. Please log in again.");
    }
    
      print('Retrieved Token from TermsAndConditions: $token');
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
        Uri.parse(Dgapi.termsAndConditions),
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      final responseBody = response.body;
      print('Get TermsAndConditions Status Code: ${response.statusCode}');
      print('Get TermsAndConditions Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = TermsAndConditions.fromJson(res);
          state = usersData;
          print("TermsAndConditions fetched successfully: ${usersData.message}");
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing TermsAndConditions.");
        }
      } else {
        print("Error fetching TermsAndConditions: ${response.body}");
        throw Exception("Error fetching TermsAndConditions: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch TermsAndConditions: $e");
    }
  }
}

final termsProvider = StateNotifierProvider<TermsNotifier, TermsAndConditions>((ref) {
  return TermsNotifier(ref);
});