import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ApiClient {
  static const String baseUrl =
      "https://unglamourous-josphine-perkingly.ngrok-free.dev"; // <-- replace

  static Future<String> startSession({
    String? patientId,
    String? doctorId,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/sessions/start'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'patient_id': patientId, 'doctor_id': doctorId}),
    );

    final data = jsonDecode(res.body);
    return data['session_id'];
  }

  static Future<void> uploadAudioChunk(
    String sessionId,
    String section,
    Uint8List bytes,
  ) async {
    final uri = Uri.parse('$baseUrl/audio/$sessionId?section=$section');

    final request = http.MultipartRequest('POST', uri);

    request.files.add(
      http.MultipartFile.fromBytes('file', bytes, filename: 'chunk.wav'),
    );

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Audio upload failed');
    }
  }

  static Future<List<dynamic>> fetchTranscript(String sessionId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/sessions/$sessionId/transcript'),
    );
    return jsonDecode(res.body);
  }

  static Future<void> finalizeSession(String sessionId) async {
    await http.post(Uri.parse('$baseUrl/sessions/$sessionId/finalize'));
  }

  static Future<Map<String, dynamic>> fetchDraft(String sessionId) async {
    final res = await http.get(Uri.parse('$baseUrl/sessions/$sessionId/draft'));

    if (res.statusCode != 200) {
      throw Exception('Failed to load draft');
    }

    return jsonDecode(res.body);
  }

  static Future<void> updateDraftField(
    String sessionId,
    String field,
    String value,
  ) async {
    final res = await http.post(
      Uri.parse('$baseUrl/sessions/$sessionId/draft/update'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'field': field, 'value': value}),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to update draft');
    }
  }

  static Future<void> uploadSectionImage(
    String sessionId,
    String section,
    XFile image,
  ) async {
    final uri = Uri.parse(
      '$baseUrl/sessions/$sessionId/sections/$section/images',
    );

    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', image.path));

    final res = await request.send();
    if (res.statusCode != 200) {
      throw Exception('Image upload failed');
    }
  }
}
