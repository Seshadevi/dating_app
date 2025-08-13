import 'dart:convert';
import 'package:dating/model/moreabout/work_model.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/utils/dating_apis.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

// Loading provider for global loading state
final loadingProvider = StateProvider<bool>((ref) => false);

class WorkProvider extends StateNotifier<List<WorkModel>> {
  final Ref ref;
  WorkProvider(this.ref) : super([]);

  Future<void> getWork() async {
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

      print('get work');

      // Use the retry client and include Authorization header
      final response = await client.get(
        Uri.parse(Dgapi.Workget),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      final responseBody = response.body;
      print('Get work Status Code: ${response.statusCode}');
      print('Get work Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
          print('Parsed JSON response: $jsonResponse');
          
          // Your API returns a single WorkModel object with data array
          final workModel = WorkModel.fromJson(jsonResponse);
          state = [workModel];
          print('Work added successfully: ${workModel.data?.length ?? 0} jobs');
          print('Jobs: ${workModel.data?.map((job) => job.title).toList()}');
        } catch (e) {
          print("Invalid response format: $e");
          print("Response body: $responseBody");
          // Set empty state on parsing error
          state = [];
          throw Exception("Error parsing work data: $e");
        }
      } else {
        print("Error fetching work: Status ${response.statusCode}, Body: ${response.body}");
        state = [];
        throw Exception("Error fetching work: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch work: $e");
      // Ensure state is set even on error
      state = [];
      rethrow;
    } finally {
      loadingState.state = false;
    }
  }

  Future<bool> addwork({required String title, required String company}) async {
  final loadingState = ref.read(loadingProvider.notifier);
  final prefs = await SharedPreferences.getInstance();

  try {
    loadingState.state = true;

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

          print("New Token: $newAccessToken");
        }
      },
    );

    final apiUrl = Uri.parse(Dgapi.workAdd);
    final request = await client.post(
      apiUrl,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        'title': title,
        'company': company,
      }),
    );

    print('Add work Status Code: ${request.statusCode}');
    print('Add work Response Body: ${request.body}');

    if (request.statusCode == 201 || request.statusCode == 200) {
      print("Work added successfully!");
      await getWork(); // Refresh
      return true;
    } else {
      final errorBody = jsonDecode(request.body);
      final errorMessage = errorBody['message'] ?? 'Unexpected error occurred.';
      print("Error adding work: $errorMessage");
      return false;
    }
  } catch (e) {
    print("Failed to add work: $e");
    return false;
  } finally {
    loadingState.state = false;
  }
}


Future<void> updateSelectedwork(
      int workId, String? company, String? role) async {
    final loadingState = ref.read(loadingProvider.notifier);
    final prefs = await SharedPreferences.getInstance();
    print('data education $workId,$company,$role');

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

      // You'll need to add this API endpoint to your Dgapi class
      final apiUrl = Uri.parse("${Dgapi.workUpdate}/$workId");
 // Add this to your API constants
      final request = await http.put(
        // or patch, depending on your API
        apiUrl,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'company': company,
          'title': role,
        }),
      );

      print('Update selected job Status Code: ${request.statusCode}');
      print('Update selected job Response Body: ${request.body}');

      if (request.statusCode == 200 || request.statusCode == 201) {
        print("Selected job updated successfully!");
        // Optionally refresh the work list to get updated data
        await getWork();
      } else {
        final errorBody =
            request.body.isNotEmpty ? jsonDecode(request.body) : {};
        final errorMessage =
            errorBody['message'] ?? 'Failed to update selected job.';
        throw Exception("Error updating selected job: $errorMessage");
      }
    } catch (e) {
      print("Failed to update selected job: $e");
      rethrow;
    } finally {
      loadingState.state = false;
    }
  }

  Future<int> deleteLanguages(int? workId) async {
    final loadingState = ref.read(loadingProvider.notifier);
    loadingState.state = true;
    final prefs = await SharedPreferences.getInstance();

    try {
      final String deleteUrl = "${Dgapi.workdelete}/$workId";
      // loadingState.state = true;

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


      final response = await http.delete(
        Uri.parse(deleteUrl),
        headers: {
          'Accept': 'application/json',
        },
      );

      print("🗑️ Delete response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 204) {
        print("✅ Deleted successfully");
        await getWork();
        return response.statusCode;
      } else {
        throw Exception("Delete failed: ${response.statusCode}");
      }
    } catch (e) {
      print("❗ Delete error: $e");
      throw Exception("Delete error: $e");
    } finally {
      loadingState.state = false;
    }
  }



}

final workProvider = StateNotifierProvider<WorkProvider, List<WorkModel>>((ref) {
  return WorkProvider(ref);
});