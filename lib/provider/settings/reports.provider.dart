import 'dart:convert';

import 'package:dating/model/settings/reportsmodel.dart';
import 'package:dating/provider/loader.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/utils/dating_apis.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ReportProvider extends StateNotifier<Reportsmodel> {
  final Ref ref;
  ReportProvider(this.ref) : super(Reportsmodel.initial());

 

  Future<bool> addReport({
    required int? categoryId,
    required String? description,
  }) async {
    final loadingState = ref.read(loadingProvider.notifier);
    final prefs = await SharedPreferences.getInstance();

    try {
      loadingState.state = true;

      // Get user ID
      // int? userId = await _getUserId();
      // if (userId == null) {
      //   print("User ID not found.");
      //   return false;
      // }
      final loginState = ref.read(loginProvider);
      int? userId = loginState.data != null && loginState.data!.isNotEmpty
          ? loginState.data![0].user?.id
          : null;

      String? userDataString = prefs.getString('userData');
      if (userDataString == null || userDataString.isEmpty) {
        print("User token is missing.");
        return false;
      }

      final Map<String, dynamic> userData = jsonDecode(userDataString);
      String? token = userData['accessToken'] ??
          (userData['data'] != null &&
                  (userData['data'] as List).isNotEmpty &&
                  userData['data'][0]['access_token'] != null
              ? userData['data'][0]['access_token']
              : null);

      if (token == null || token.isEmpty) {
        print("User token is invalid.");
        return false;
      }

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

            await prefs.setString('accessToken', newAccessToken ?? '');
            token = newAccessToken;
            req.headers['Authorization'] = 'Bearer $newAccessToken';
          }
        },
      );

      final apiUrl = Uri.parse(Dgapi.reportAdd);
      
      final requestBody = {
        'userId': userId,
        'categoryId': categoryId,
        'description': description,
      };

      print("Request body: ${jsonEncode(requestBody)}");

      final response = await client.post(
        apiUrl,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      print("Report API Status: ${response.statusCode}");
      print("Report API Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Report added successfully!");
        
        // Optionally update the state with the new report
        try {
          final responseData = jsonDecode(response.body);
          if (responseData['data'] != null) {
            // You can update the state here if the API returns the created report
            print("Report created with data: ${responseData['data']}");
          }
        } catch (e) {
          print("Error parsing response data: $e");
        }
        
        return true;
      } else {
        final errorBody = jsonDecode(response.body);
        final errorMessage =
            errorBody['message'] ?? 'Unexpected error occurred.';
        print("Error adding report: $errorMessage");
        return false;
      }
    } catch (e) {
      print("Exception during report add: $e");
      return false;
    } finally {
      loadingState.state = false;
    }
  }

  // Method to get all reports (if needed)
  Future<void> getReports() async {
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

            await prefs.setString('accessToken', newAccessToken ?? '');
            token = newAccessToken;
            req.headers['Authorization'] = 'Bearer $newAccessToken';
          }
        },
      );

      // Assuming you have a get reports API endpoint
      final response = await client.get(
        Uri.parse(Dgapi.reportGet), // You'll need to add this to your API constants
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Get Reports Status Code: ${response.statusCode}');
      print('Get Reports Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final res = jsonDecode(response.body);
        final reportsData = Reportsmodel.fromJson(res);
        state = reportsData;
        print('Reports fetched successfully');
      } else {
        print("Error fetching reports: ${response.body}");
        throw Exception("Error fetching reports: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch reports: $e");
    } finally {
      loadingState.state = false;
    }
  }
}

final reportProvider =
    StateNotifierProvider<ReportProvider, Reportsmodel>((ref) {
  return ReportProvider(ref);
});