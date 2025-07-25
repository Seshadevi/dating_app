

import 'package:dating/model/moreabout/starsignmodel.dart';

import 'package:dating/provider/loader.dart';

import 'package:dating/utils/dating_apis.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class StarSignProvider extends StateNotifier<Starsignmodel> {
  final Ref ref;
  StarSignProvider(this.ref) : super(Starsignmodel.initial());
  
  Future<void> getStarsign() async {
    final loadingState = ref.read(loadingProvider.notifier);
    try {
      loadingState.state = true;
      
      print('get starsign');

     final response = await http.get(
        Uri.parse(Dgapi.starsignGet));
      final responseBody = response.body;
      print('Get starsign Status Code: ${response.statusCode}');
      print('Get starsign Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = Starsignmodel.fromJson(res);
          state = usersData;
          print('get starsign successfully');
          
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing starsign");
        }
      } else {
        print("Error fetching starsign: ${response.body}");
        throw Exception("Error fetching starsign: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch starsign: $e");
    }finally{
      loadingState.state = false;
    }
  }
}

final starSignProvider = StateNotifierProvider<StarSignProvider, Starsignmodel>((ref) {
  return StarSignProvider(ref);
});