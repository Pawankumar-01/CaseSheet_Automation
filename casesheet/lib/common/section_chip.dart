import 'package:flutter/material.dart';

class SectionChip extends StatelessWidget {
  final String label;
  const SectionChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(label));
  }
}
