import 'package:flutter/material.dart';

// import '../casesheet/casesheet_view.dart';
// import 'fact_review_page.dart';
import '../casesheet/section_based_casesheet.dart';
import '../../common/mic_button.dart';
import '../../services/audio_service.dart';
import '../../routes.dart';

class RecordingPage extends StatefulWidget {
  final String sessionId;

  const RecordingPage({
    super.key,
    required this.sessionId,
  });

  @override
  State<RecordingPage> createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {

  @override
  Widget build(BuildContext context) {
    final sessionId = widget.sessionId;

    return Scaffold(
      appBar: AppBar(title: const Text('Consultation')),
      body: Column(
        children: [
          Expanded(
            child: SectionBasedCaseSheet(sessionId: sessionId),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(
            context,
            Routes.factReview,
            arguments: sessionId,
          );
        },
        label: const Text('Review & Finalize'),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
