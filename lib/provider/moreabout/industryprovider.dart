
import 'package:dating/model/moreabout/industrymodel.dart';

import 'package:dating/provider/loader.dart';

import 'package:dating/utils/dating_apis.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class Industryprovider extends StateNotifier<Industrymodel> {
  final Ref ref;
  Industryprovider(this.ref) : super(Industrymodel.initial());
  
  Future<void> getIndustry() async {
    final loadingState = ref.read(loadingProvider.notifier);
    try {
      loadingState.state = true;
      
      print('get Industry');

     final response = await http.get(
        Uri.parse(Dgapi.industryget));
      final responseBody = response.body;
      print('Get Industry Status Code: ${response.statusCode}');
      print('Get Industry Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = Industrymodel.fromJson(res);
          state = usersData;
          print('get Industry successfully');
          
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing Industry.");
        }
      } else {
        print("Error fetching Industry: ${response.body}");
        throw Exception("Error fetching Industry: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch Industry: $e");
    }
    finally {
      loadingState.state = false;
    }
  }
}

final industryprovider = StateNotifierProvider<Industryprovider, Industrymodel>((ref) {
  return Industryprovider(ref);
});