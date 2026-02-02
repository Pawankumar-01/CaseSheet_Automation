import 'package:flutter/material.dart';
import '../../services/api_client.dart';
import 'section_card.dart';

class SectionBasedCaseSheet extends StatefulWidget {
  final String sessionId;
  final bool readOnly;

  const SectionBasedCaseSheet({
    super.key,
    required this.sessionId,
    this.readOnly = false,
  });

  @override
  State<SectionBasedCaseSheet> createState() => _SectionBasedCaseSheetState();
}

class _SectionBasedCaseSheetState extends State<SectionBasedCaseSheet> {
  Map<String, dynamic> draft = {};
  bool loading = true;

  static const sections = [
    'chief_complaint',
    'anamnesis',
    'treatment_and_background',
    'personal_history',
    'review_of_systems',
    'systemic_examination',
    'past_medical_history',
    'assessment_and_plan',
  ];

  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  Future<void> _loadDraft() async {
    final data = await ApiClient.fetchDraft(widget.sessionId);

    setState(() {
      // ✅ store ONLY sections map
      draft = data['sections'] ?? {};
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadDraft,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final key = sections[index];

          return SectionCard(
            sessionId: widget.sessionId,
            sectionKey: key,
            sectionData: draft[key], // ✅ CORRECT
            onUpdated: _loadDraft,
            readOnly: widget.readOnly,
          );
        },
      ),
    );
  }
}
