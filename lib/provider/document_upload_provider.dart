import 'dart:convert';
import 'dart:io';

import 'package:dating/model/document_model.dart';
import 'package:dating/provider/loader.dart';
import 'package:dating/provider/loginProvider.dart';
import 'package:dating/utils/dating_apis.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DocumentProvider extends StateNotifier<DocumentID> {
  final Ref ref;
  DocumentProvider(this.ref) : super(DocumentID.initial());

  /// POST /users/{userId}/verification
  /// form-data: images (selfie), images (aadhar), images (pan)
  Future<void> sendDocuments({
    required File selfie,
    required File aadhar,
    required File pan,
  }) async {
    final loading = ref.read(loadingProvider.notifier);
    loading.state = true;

    RetryClient? client;
    try {
      // ---- user id ----
      final userId = ref.read(loginProvider).data?[0].user?.id;
      if (userId == null) throw Exception('Missing userId. Please log in again.');

      // ---- token ----
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('userData');
      if (userDataString == null || userDataString.isEmpty) {
        throw Exception('User token is missing. Please log in again.');
      }
      final Map<String, dynamic> userData = jsonDecode(userDataString);

      String? token = userData['accessToken'] ??
          ((userData['data'] is List && (userData['data'] as List).isNotEmpty)
              ? userData['data'][0]['access_token']
              : null) ??
          prefs.getString('accessToken');

      if (token == null || token.isEmpty) {
        throw Exception('User token is invalid. Please log in again.');
      }

      // ---- URL ----
      // Dgapi.verification should be like: "$baseUrl/users/userid/verification"
      final urlStr = Dgapi.verification.replaceFirst('userid', '$userId');
      final uri = Uri.parse(urlStr);

      // ---- RetryClient with token refresh ----
      client = RetryClient(
        http.Client(),
        retries: 3,
        when: (res) => res.statusCode == 400 || res.statusCode == 401,
        onRetry: (req, res, attempt) async {
          if (attempt == 0 && (res?.statusCode == 400 || res?.statusCode == 401)) {
            final newToken =
                await ref.read(loginProvider.notifier).restoreAccessToken();
            if (newToken != null && newToken.isNotEmpty) {
              await prefs.setString('accessToken', newToken);
              token = newToken;
              req.headers['Authorization'] = 'Bearer $newToken';
            }
          }
        },
      );

      // ---- Multipart request (IMPORTANT: do NOT set Content-Type manually) ----
      final req = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['Accept'] = 'application/json';

      // Same field name "images" for all three files
      Future<void> addImage(String fieldName, File file) async {
        final path = file.path;
        final ext = path.split('.').last.toLowerCase();
        MediaType type;
        if (ext == 'jpg' || ext == 'jpeg') {
          type = MediaType('image', 'jpeg');
        } else if (ext == 'png') {
          type = MediaType('image', 'png');
        } else {
          throw Exception('Unsupported file type: .$ext (only jpg/png)');
        }
        req.files.add(await http.MultipartFile.fromPath(
          fieldName, // "images"
          path,
          contentType: type,
        ));
      }

      await addImage('images', selfie);
      await addImage('images', aadhar);
      await addImage('images', pan);

      // ---- Send via RetryClient ----
      final streamed = await client.send(req);
      final res = await http.Response.fromStream(streamed);

      if (res.statusCode == 200 || res.statusCode == 201) {
        // Update state from response, if server returns details
        try {
          state = DocumentID.fromJson(jsonDecode(res.body));
        } catch (_) {
          // fallback to set message only
          state = state.copyWith(message: 'Uploaded successfully', userId: userId);
        }
      } else {
        String msg = 'Upload failed (${res.statusCode})';
        try {
          final err = jsonDecode(res.body);
          msg = (err['message'] ?? msg).toString();
        } catch (_) {}
        throw Exception(msg);
      }
    } finally {
      // await client?.close();
      loading.state = false;
    }
  }
}

final documentProvider =
    StateNotifierProvider<DocumentProvider, DocumentID>((ref) {
  return DocumentProvider(ref);
});
