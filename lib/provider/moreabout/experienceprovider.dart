
import 'package:dating/model/moreabout/experiencemodel.dart';
import 'package:dating/model/moreabout/languagemodel.dart';

import 'package:dating/provider/loader.dart';

import 'package:dating/utils/dating_apis.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ExperienceProvider extends StateNotifier<Experiencemodel> {
  final Ref ref;
  ExperienceProvider(this.ref) : super(Experiencemodel.initial());
  
  Future<void> getExperience() async {
    final loadingState = ref.read(loadingProvider.notifier);
    try {
      loadingState.state = true;
      
      print('get Experience');

     final response = await http.get(
        Uri.parse(Dgapi.experienceget));
      final responseBody = response.body;
      print('Get Experience Status Code: ${response.statusCode}');
      print('Get Experience Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = Experiencemodel.fromJson(res);
          state = usersData;
          print('get Experience successfully');
          
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing Experience.");
        }
      } else {
        print("Error fetching Experience: ${response.body}");
        throw Exception("Error fetching Experience: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch Experience: $e");
    }
    finally {
      loadingState.state = false;
    }
  }
}

final experienceProvider = StateNotifierProvider<ExperienceProvider, Experiencemodel>((ref) {
  return ExperienceProvider(ref);
});