
import 'package:dating/model/signupprocessmodels/kidsModel.dart';
import 'package:dating/provider/loader.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/utils/dating_apis.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class KidsNotifier extends StateNotifier<KidsModel> {
  final Ref ref;
  KidsNotifier(this.ref) : super(KidsModel.initial());
  
  Future<void> getKids() async {
    final loadingState = ref.read(loadingProvider.notifier);
    try {
      loadingState.state = true;

      print('get Kids');

   
      final response = await http.get(
        Uri.parse(Dgapi.kids)        
      );
      final responseBody = response.body;
      print('Get kids Status Code: ${response.statusCode}');
      print('Get kids Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = KidsModel.fromJson(res);
          state = usersData;
          print("kids fetched successfully: ${usersData.message}");
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing kids .");
        }
      } else {
        print("Error fetching kids : ${response.body}");
        throw Exception("Error fetching kids : ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch kids : $e");
    }
  }
}

final kidsProvider = StateNotifierProvider<KidsNotifier, KidsModel>((ref) {
  return KidsNotifier(ref);
});