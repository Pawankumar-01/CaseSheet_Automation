import 'package:flutter/material.dart';

import '../../models/clinical_fact.dart';
import '../../services/fact_api.dart';

class FactReviewPage extends StatefulWidget {
  final String sessionId;
  const FactReviewPage({super.key, required this.sessionId});

  @override
  State<FactReviewPage> createState() => _FactReviewPageState();
}

class _FactReviewPageState extends State<FactReviewPage> {
  late Future<List<ClinicalFact>> _factsFuture;

  @override
  void initState() {
    super.initState();
    _factsFuture = FactApi.fetchFacts(widget.sessionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Review Consultation')),
      body: FutureBuilder<List<ClinicalFact>>(
        future: _factsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load facts',
                style: TextStyle(color: Colors.red.shade600),
              ),
            );
          }

          final facts = snapshot.data ?? [];

          if (facts.isEmpty) {
            return const Center(
              child: Text('No clinical facts detected.'),
            );
          }

          final grouped = _groupByIntent(facts);

          return ListView(
            padding: const EdgeInsets.all(12),
            children: grouped.entries
                .map((entry) => _buildIntentSection(entry.key, entry.value))
                .toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Next step: navigate to finalize page
        },
        label: const Text('Confirm & Finalize'),
        icon: const Icon(Icons.check),
      ),
    );
  }

  // ---------------- HELPERS ----------------

  Map<String, List<ClinicalFact>> _groupByIntent(List<ClinicalFact> facts) {
    final map = <String, List<ClinicalFact>>{};
    for (final fact in facts) {
      map.putIfAbsent(fact.intent, () => []).add(fact);
    }
    return map;
  }

  Widget _buildIntentSection(String intent, List<ClinicalFact> facts) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(intent.replaceAll('_', ' ').toUpperCase()),
        children: facts.map(_buildFactTile).toList(),
      ),
    );
  }

  Widget _buildFactTile(ClinicalFact fact) {
    return ListTile(
      title: Text(fact.name),
      subtitle: Text(
        [
          if (fact.severity != null && fact.severity!.isNotEmpty)
            'Severity: ${fact.severity}',
          if (fact.duration != null && fact.duration!.isNotEmpty)
            'Duration: ${fact.duration}',
        ].join(' • '),
      ),
      leading: Switch(
        value: fact.status == 'present',
        onChanged: (val) {
          setState(() {
            fact.status = val ? 'present' : 'absent';
          });
          FactApi.updateFact(widget.sessionId, fact);
        },
      ),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () => _editFactDialog(fact),
      ),
    );
  }

  void _editFactDialog(ClinicalFact fact) {
    final nameCtrl = TextEditingController(text: fact.name);
    final severityCtrl =
        TextEditingController(text: fact.severity ?? '');
    final durationCtrl =
        TextEditingController(text: fact.duration ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Fact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: severityCtrl,
              decoration: const InputDecoration(labelText: 'Severity'),
            ),
            TextField(
              controller: durationCtrl,
              decoration: const InputDecoration(labelText: 'Duration'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                fact.name = nameCtrl.text;
                fact.severity =
                    severityCtrl.text.isEmpty ? null : severityCtrl.text;
                fact.duration =
                    durationCtrl.text.isEmpty ? null : durationCtrl.text;
              });
              FactApi.updateFact(widget.sessionId, fact);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          )
        ],
      ),
    );
  }
}
