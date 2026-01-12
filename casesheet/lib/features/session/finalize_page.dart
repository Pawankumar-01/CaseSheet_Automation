import 'package:flutter/material.dart';

import '../../services/api_client.dart';
import '../casesheet/casesheet_view.dart';

class FinalizePage extends StatelessWidget {
  final String sessionId;

  const FinalizePage({
    super.key,
    required this.sessionId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Finalize Case Sheet')),
      body: Column(
        children: [
          Expanded(
            child: CaseSheetView(sessionId: sessionId),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                await ApiClient.finalizeSession(sessionId);
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Finalize & Lock'),
            ),
          ),
        ],
      ),
    );
  }
}
