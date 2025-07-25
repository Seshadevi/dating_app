import 'dart:convert';
import 'package:dating/model/moreabout/WorkModel.dart';
import 'package:dating/provider/loader.dart';
import 'package:dating/utils/dating_apis.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class WorkProvider extends StateNotifier<List<WorkModel>> {
  final Ref ref;
  WorkProvider(this.ref) : super([]);

  Future<void> getWork() async {
    final loadingState = ref.read(loadingProvider.notifier);
    try {
      loadingState.state = true;

      print('get work');

      final response = await http.get(Uri.parse(Dgapi.Workget));
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
          print('Work loaded successfully: ${workModel.data?.length ?? 0} jobs');
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

  Future<void> addwork({required String title, required String company}) async {
    final loadingState = ref.read(loadingProvider.notifier);

    try {
      loadingState.state = true;

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception("User token not found.");
      }

      final apiUrl = Uri.parse(Dgapi.workAdd);
      final request = await http.post(
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
        // Refresh the work list after adding
        await getWork();
      } else {
        final errorBody = jsonDecode(request.body);
        final errorMessage = errorBody['message'] ?? 'Unexpected error occurred.';
        throw Exception("Error adding work: $errorMessage");
      }
    } catch (e) {
      print("Failed to add work: $e");
      rethrow;
    } finally {
      loadingState.state = false;
    }
  }

  // Helper method to get all jobs from all work models
  List<Data> getAllJobs() {
    final List<Data> allJobs = [];
    for (final workModel in state) {
      if (workModel.data != null) {
        allJobs.addAll(workModel.data!);
      }
    }
    return allJobs;
  }

  // Helper method to check if jobs are loading
  bool get isLoading {
    return state.any((workModel) => workModel.isLoading);
  }
}

final workProvider = StateNotifierProvider<WorkProvider, List<WorkModel>>((ref) {
  return WorkProvider(ref);
});