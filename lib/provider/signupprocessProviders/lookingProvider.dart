
import 'package:dating/model/signupprocessmodels/lookingModel.dart';
import 'package:dating/provider/loader.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/utils/dating_apis.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class LookingNotifier extends StateNotifier<LookingForUser> {
  final Ref ref;
  LookingNotifier(this.ref) : super(LookingForUser.initial());
  
  Future<void> getLookingForUser() async {
    final loadingState = ref.read(loadingProvider.notifier);
    try {
      loadingState.state = true;
      
      print('get LookingForUser');
      
      final response = await http.get(
        Uri.parse(Dgapi.lookingFor)
      );
      final responseBody = response.body;
      print('Get LookingForUser Status Code: ${response.statusCode}');
      print('Get LookingForUser Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = LookingForUser.fromJson(res);
          state = usersData;
          print("LookingForUser fetched successfully: ${usersData.message}");
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing LookingForUser");
        }
      } else {
        print("Error fetching LookingForUser: ${response.body}");
        throw Exception("Error fetching LookingForUser: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch LookingForUser: $e");
    }
  }
}

final lookingProvider = StateNotifierProvider<LookingNotifier,LookingForUser>((ref) {
  return LookingNotifier(ref);
});