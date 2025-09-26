import 'package:dating/model/moreabout/realtionshipsmodel.dart';
import 'package:dating/provider/loader.dart';
import 'package:dating/utils/dating_apis.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class RelationshipProvider extends StateNotifier<RelationshipModel> {
  final Ref ref;
  RelationshipProvider(this.ref) : super(RelationshipModel.initial());
  
  Future<void> getRelationship() async {
    
    final loadingState = ref.read(loadingProvider.notifier);
    try {
      loadingState.state = true;
     
      print('get Relationship');

      final response = await http.get(
        Uri.parse(Dgapi.relationshipget));
      final responseBody = response.body;
      print('Get Relationship Status Code: ${response.statusCode}');
      print('Get Relationship Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = RelationshipModel.fromJson(res);
          state = usersData;
          print("Relationship fetched successfully: ${usersData.message}");
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing Relationship.");
        }
      } else {
        print("Error fetching Relationship: ${response.body}");
        throw Exception("Error fetching Relationship: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch Relationship $e");
    }
  }
  


}

final relationshipProvider = StateNotifierProvider<RelationshipProvider, RelationshipModel>((ref) {
  return RelationshipProvider(ref);
});