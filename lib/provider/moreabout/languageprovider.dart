
import 'package:dating/model/moreabout/languagemodel.dart';

import 'package:dating/provider/loader.dart';

import 'package:dating/utils/dating_apis.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class LanguagesProvider extends StateNotifier<LanguagesModel> {
  final Ref ref;
  LanguagesProvider(this.ref) : super(LanguagesModel.initial());
  
  Future<void> getLanguage() async {
    final loadingState = ref.read(loadingProvider.notifier);
    try {
      loadingState.state = true;
      
      print('get languages');

     final response = await http.get(
        Uri.parse(Dgapi.laguagesGet));
      final responseBody = response.body;
      print('Get modes Status Code: ${response.statusCode}');
      print('Get modes Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = LanguagesModel.fromJson(res);
          state = usersData;
          print('get languages successfully');
          
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing languages.");
        }
      } else {
        print("Error fetching languages: ${response.body}");
        throw Exception("Error fetching languages: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch languages: $e");
    }
    finally {
      loadingState.state = false;
    }
  }
}

final languagesProvider = StateNotifierProvider<LanguagesProvider, LanguagesModel>((ref) {
  return LanguagesProvider(ref);
});