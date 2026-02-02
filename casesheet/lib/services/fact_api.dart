import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/clinical_fact.dart';
import '../models/casesheet.dart';
import 'casesheet_mapper.dart';

class FactApi {
  static const baseUrl = 'https://unglamourous-josphine-perkingly.ngrok-free.dev';

  static Future<List<ClinicalFact>> fetchFacts(String sessionId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/sessions/$sessionId/facts'),
    );

    final data = jsonDecode(res.body);
    return (data['facts'] as List)
        .map((f) => ClinicalFact.fromJson(f))
        .toList();
  }

  static Future<void> updateFact(
    String sessionId,
    ClinicalFact fact,
  ) async {
    await http.post(
      Uri.parse('$baseUrl/sessions/$sessionId/facts/${fact.factId}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': fact.name,
        'status': fact.status,
        'severity': fact.severity,
        'duration': fact.duration,
      }),
    );
  }
  static Future<CaseSheet> fetchFullCaseSheet(String sessionId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/sessions/$sessionId/case-sheet'),
    );

    final data = jsonDecode(res.body);
    // This uses your existing CaseSheetMapper.fromBackend
    return CaseSheetMapper.fromBackend(data);
  }
}
