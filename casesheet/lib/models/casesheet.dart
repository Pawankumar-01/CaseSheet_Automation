import 'field_types.dart';

class CaseField {
  final String key;
  final FieldType type;
  dynamic value;
  double confidence;
  bool verified;

  CaseField({
    required this.key,
    required this.type,
    this.value,
    this.confidence = 0.0,
    this.verified = false,
  });
}

class CaseSection {
  final String title;
  final List<CaseField> fields;

  CaseSection({required this.title, required this.fields});
}

class CaseSheet {
  final List<CaseSection> sections;
  bool finalized;

  CaseSheet({required this.sections, this.finalized = false});

  static CaseSheet mock() {
    return CaseSheet(sections: [
      CaseSection(title: 'Chief Complaint', fields: [
        CaseField(
            key: 'Complaint',
            type: FieldType.text,
            value: 'Lower back pain',
            confidence: 0.93),
        CaseField(
            key: 'Duration',
            type: FieldType.text,
            value: '6 months',
            confidence: 0.88),
      ]),
      CaseSection(title: 'Review of Systems', fields: [
        CaseField(
            key: 'GI Abdominal Pain',
            type: FieldType.nowPast,
            value: {'now': false, 'past': true},
            confidence: 0.95),
      ]),
    ]);
  }
}
