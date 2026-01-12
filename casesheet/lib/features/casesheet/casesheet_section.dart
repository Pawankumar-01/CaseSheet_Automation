import 'package:flutter/material.dart';
import '../../models/casesheet.dart';
import 'field_widget.dart';

class CaseSheetSection extends StatelessWidget {
  final CaseSection section;
  const CaseSheetSection({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(section.title),
      children: section.fields
          .map((field) => FieldWidget(field: field))
          .toList(),
    );
  }
}
