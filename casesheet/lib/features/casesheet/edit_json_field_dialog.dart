import 'package:flutter/material.dart';

class EditJsonFieldDialog extends StatelessWidget {
  final String title;
  final String initialValue;

  const EditJsonFieldDialog({
    super.key,
    required this.title,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: initialValue);

    return AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        maxLines: null,
        decoration: const InputDecoration(border: OutlineInputBorder()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, controller.text.trim());
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
