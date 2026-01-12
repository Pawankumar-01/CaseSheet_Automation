import 'package:flutter/material.dart';
import '../../services/api_client.dart';

class TranscriptPanel extends StatefulWidget {
  final String sessionId;
  const TranscriptPanel({super.key, required this.sessionId});

  @override
  State<TranscriptPanel> createState() => _TranscriptPanelState();
}

class _TranscriptPanelState extends State<TranscriptPanel> {
  List<dynamic> transcript = [];

  @override
  void initState() {
    super.initState();
    _pollTranscript();
  }

  void _pollTranscript() async {
    while (mounted) {
      final data = await ApiClient.fetchTranscript(widget.sessionId);
      setState(() => transcript = data);
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(12),
      color: Colors.grey.shade100,
      child: ListView(
        children: transcript
            .map((t) => Text(t['text'], style: const TextStyle(fontSize: 14)))
            .toList(),
      ),
    );
  }
}
