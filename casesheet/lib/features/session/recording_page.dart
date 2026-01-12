import 'package:flutter/material.dart';

import '../casesheet/casesheet_view.dart';
import 'transcript_panel.dart';
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
  bool isRecording = false;
  late final AudioService _audioService;

  @override
  void initState() {
    super.initState();
    _audioService = AudioService();
    _audioService.setSession(widget.sessionId);
  }

  Future<void> _toggleRecording() async {
    if (isRecording) {
      await _audioService.stopAndSendChunk();
    } else {
      await _audioService.startRecording();
    }

    setState(() {
      isRecording = !isRecording;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sessionId = widget.sessionId;

    return Scaffold(
      appBar: AppBar(title: const Text('Consultation')),
      body: Column(
        children: [
          TranscriptPanel(sessionId: sessionId),
          Expanded(child: CaseSheetView(sessionId: sessionId)),
          MicButton(
            isRecording: isRecording,
            onToggle: _toggleRecording,
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
