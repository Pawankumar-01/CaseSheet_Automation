import 'package:flutter/material.dart';
import '../../services/api_client.dart';
import '../../routes.dart';

class StartSessionPage extends StatelessWidget {
  const StartSessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Start Consultation')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Start a new clinical consultation',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            // Optional for now — backend already supports nulls
            const Text('Patient ID (optional)'),
            const SizedBox(height: 4),
            const TextField(),

            const SizedBox(height: 16),

            const Text('Doctor ID (optional)'),
            const SizedBox(height: 4),
            const TextField(),

            const Spacer(),

            ElevatedButton(
              onPressed: () async {
                final sessionId = await ApiClient.startSession();

                Navigator.pushNamed(
                  context,
                  Routes.recording, // ✅ CORRECT DESTINATION
                  arguments: sessionId,
                );
              },
              child: const Text('Start Consultation'),
            ),
          ],
        ),
      ),
    );
  }
}
