import 'package:dating/model/peoples_all_model.dart';
import 'package:dating/model/plans/plans.dart';
import 'package:dating/provider/loader.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/utils/dating_apis.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlansProvider extends StateNotifier<PlansModel> {
  final Ref ref;
  PlansProvider(this.ref) : super(PlansModel.initial());

  Future<void> getPlans() async {
    final loadingState = ref.read(loadingProvider.notifier);
    final prefs = await SharedPreferences.getInstance();

    try {
      loadingState.state = true;

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

            await prefs.setString('accessToken', newAccessToken);
            token = newAccessToken; // ✅ Update token for next use
            req.headers['Authorization'] = 'Bearer $newAccessToken';
            print("New Token: $newAccessToken");
          }
        },
      );

      // ✅ Now use the possibly updated token here
      final response = await client.get(
        Uri.parse(Dgapi.plans),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final responseBody = response.body;

      print('Get plans Status Code: ${response.statusCode}');
      print('Get plans Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = PlansModel.fromJson(res);
          state = usersData;

          await prefs.setString('userData', jsonEncode(res));

          print("plans fetched successfully: ${usersData}");
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing peoples.");
        }
      } else {
        print("Error fetching plans: ${response.body}");
        throw Exception("Error fetching plans: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch plans: $e");
    } finally {
      loadingState.state = false;
    }
  }
}

final plansProvider =
    StateNotifierProvider<PlansProvider, PlansModel>((ref) {
  return PlansProvider(ref);
});
