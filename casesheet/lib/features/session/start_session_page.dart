import 'package:flutter/material.dart';
import '../../services/api_client.dart';

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
            const Text('Patient ID'),
            const TextField(),
            const SizedBox(height: 16),
            const Text('Doctor ID'),
            const TextField(),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                final sessionId = await ApiClient.startSession();
                Navigator.pushNamed(
                  context,
                  '/recording',
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
