import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

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
    Uint8List bytes,
  ) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/audio/$sessionId'),
    );

    request.files.add(
      http.MultipartFile.fromBytes('file', bytes, filename: 'chunk.wav'),
    );

    await request.send();
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
  final res = await http.get(
    Uri.parse('$baseUrl/sessions/$sessionId/draft'),
  );
  return jsonDecode(res.body);}

}



