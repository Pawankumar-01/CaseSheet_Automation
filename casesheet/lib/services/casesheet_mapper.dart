import '../models/casesheet.dart';
import '../models/field_types.dart';

class CaseSheetMapper {
  static CaseSheet fromBackend(Map<String, dynamic> data) {
    final sections = <CaseSection>[];

    data['sections'].forEach((sectionName, fields) {
      final sectionFields = <CaseField>[];

      fields.forEach((key, value) {
        sectionFields.add(
          CaseField(
            key: key,
            type: FieldType.text,
            value: value,
            confidence: 0.0,
          ),
        );
      });

      sections.add(
        CaseSection(title: sectionName, fields: sectionFields),
      );
    });

    return CaseSheet(
      sections: sections,
      finalized: data['finalized'] ?? false,
    );
  }
}
