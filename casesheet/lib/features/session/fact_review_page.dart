import 'package:flutter/material.dart';
import '../../services/api_client.dart';
import '../casesheet/section_based_casesheet.dart';

class FactReviewPage extends StatefulWidget {
  final String sessionId;
  const FactReviewPage({super.key, required this.sessionId});

  @override
  State<FactReviewPage> createState() => _FactReviewPageState();
}

class _FactReviewPageState extends State<FactReviewPage> {
  late Future<Map<String, dynamic>> _draftFuture;

  @override
  void initState() {
    super.initState();
    _draftFuture = ApiClient.fetchDraft(widget.sessionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Case Sheet'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _draftFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final draft = snapshot.data!;
          final sections = draft['sections'] as Map<String, dynamic>?;

          if (sections == null || sections.isEmpty) {
            return const Center(
              child: Text('No case sheet data available'),
            );
          }

          // 🔒 READ-ONLY PREVIEW (single source of truth)
          return SectionBasedCaseSheet(
            sessionId: widget.sessionId,
            readOnly: true,
          );
        },
      ),
    );
  }
}
