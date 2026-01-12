import 'package:flutter/material.dart';
import '../../models/casesheet.dart';
import '../../models/field_types.dart';

class EditFieldDialog extends StatefulWidget {
  final CaseField field;
  const EditFieldDialog({super.key, required this.field});

  @override
  State<EditFieldDialog> createState() => _EditFieldDialogState();
}

class _EditFieldDialogState extends State<EditFieldDialog> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(
        text: widget.field.value?.toString() ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit ${widget.field.key}'),
      content: TextField(
        controller: controller,
        maxLines: widget.field.type == FieldType.multiText ? 5 : 1,
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        ElevatedButton(
            onPressed: () {
              widget.field.value = controller.text;
              widget.field.verified = true;
              Navigator.pop(context);
            },
            child: const Text('Save')),
      ],
    );
  }
}
