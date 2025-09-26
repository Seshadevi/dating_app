
import 'package:dating/model/moreabout/sportsmodel.dart';
import 'package:dating/provider/loader.dart';
import 'package:dating/utils/dating_apis.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sportsprovider extends StateNotifier<Sportsmodel> {
  final Ref ref;
  Sportsprovider(this.ref) : super(Sportsmodel.initial());

  Future<void> getSports() async {
    final loadingState = ref.read(loadingProvider.notifier);
    try {
      loadingState.state = true;

      print('get Sports');

      final response = await http.get(Uri.parse(Dgapi.sportsget));
      final responseBody = response.body;
      print('Get Sports Status Code: ${response.statusCode}');
      print('Get Sports Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = Sportsmodel.fromJson(res);
          state = usersData;
          print("Sports fetched successfully");
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing Sports.");
        }
      } else {
        print("Error fetching Sports: ${response.body}");
        throw Exception("Error fetching Sports: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch Sports $e");
    }
  }
}

final sportsprovider =
    StateNotifierProvider<Sportsprovider, Sportsmodel>((ref) {
  return Sportsprovider(ref);
});
