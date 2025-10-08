import 'dart:convert';
// import 'package:dating/model/TravelModeldart';
import 'package:dating/model/settings/travelmodel.dart';
import 'package:dating/provider/loader.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/utils/dating_apis.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TravelProvider extends StateNotifier<TravelModel> {
  final Ref ref; // To access other providers
  TravelProvider(this.ref) : super((TravelModel.initial()));

  Future<Map<String, dynamic>> addTravel(
  bool? toggle,
  double latitude,
  double longitude,
) async {
  final loadingState = ref.read(loadingProvider.notifier);
  loadingState.state = true;
  print('Toggle travel mode: $toggle, lat: $latitude, lng: $longitude');

  try {
    final prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('userData');
    final apiUrl = Uri.parse(Dgapi.traveladd);

    if (userDataString == null || userDataString.isEmpty) {
      throw Exception("User token is missing. Please log in again.");
    }

    final Map<String, dynamic> userData = jsonDecode(userDataString);
    String? token = userData['accessToken'];

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

    print('Retrieved Token: $token');

    final client = RetryClient(
      http.Client(),
      retries: 3,
      when: (response) =>
          response.statusCode == 400 || response.statusCode == 401,
      onRetry: (req, res, retryCount) async {
        if (retryCount == 0 && (res?.statusCode == 400 || res?.statusCode == 401)) {
          String? newAccessToken = await ref.read(loginProvider.notifier).restoreAccessToken();
          print('Restored Token: $newAccessToken');
          req.headers['Authorization'] = 'Bearer $newAccessToken';
        }
      },
    );

    final response = await client.post(
      apiUrl,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        'travelMode': toggle,
        'location': '$latitude,$longitude',
      }),
    );

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Travel added successfully!");
      return {
        'statusCode': response.statusCode,
        'message': responseBody['message'] ?? 'Travel added successfully!',
      };
    } else {
      final errorMessage = responseBody['message'] ?? 'Unexpected error occurred.';
      return {
        'statusCode': response.statusCode,
        'message': errorMessage,
      };
    }
  } catch (error) {
    print("Failed to add traveluser: $error");
    return {
      'statusCode': 500,
      'message': error.toString(),
    };
  } finally {
    loadingState.state = false;
  }
}

}

final travelProvider =
    StateNotifierProvider<TravelProvider, TravelModel>((ref) {
  return TravelProvider(ref);
});
