import 'package:flutter/material.dart';
import '../../models/casesheet.dart';
import 'edit_field_dialog.dart';

class FieldWidget extends StatelessWidget {
  final CaseField field;
  const FieldWidget({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(field.key),
      subtitle: Text(field.value?.toString() ?? ''),
      trailing: Text('${(field.confidence * 100).round()}%'),
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => EditFieldDialog(field: field),
        );
      },
    );
  }
}
