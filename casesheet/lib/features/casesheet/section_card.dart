import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/mic_button.dart';
import '../../services/audio_service.dart';
import '../../services/api_client.dart';
import 'edit_json_field_dialog.dart';

class SectionCard extends StatefulWidget {
  final String sessionId;
  final String sectionKey;
  final dynamic sectionData;
  final VoidCallback onUpdated;
  final bool readOnly;

  const SectionCard({
    super.key,
    required this.sessionId,
    required this.sectionKey,
    required this.sectionData,
    required this.onUpdated,
    this.readOnly = false,
  });

  @override
  State<SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<SectionCard> {
  bool recording = false;
  late final AudioService audioService;

  @override
  void initState() {
    super.initState();
    audioService = AudioService()
      ..setSession(widget.sessionId)
      ..setSection(widget.sectionKey);
  }

  // =========================
  // EDIT FIELD
  // =========================

  Future<void> _editField(String fieldPath, String currentValue) async {
    if (widget.readOnly) return;

    final updated = await showDialog<String>(
      context: context,
      builder: (_) => EditJsonFieldDialog(
        title: fieldPath.replaceAll('.', ' ').toUpperCase(),
        initialValue: currentValue,
      ),
    );

    if (updated == null || updated == currentValue) return;

    await ApiClient.updateDraftField(
      widget.sessionId,
      fieldPath,
      updated,
    );

    widget.onUpdated();
  }

  // =========================
  // RECORDING
  // =========================

  Future<void> _toggleRecording() async {
    if (widget.readOnly) return;

    if (recording) {
      await audioService.stopAndSendChunk();
      widget.onUpdated();
    } else {
      await audioService.startRecording();
    }

    setState(() => recording = !recording);
  }

  // =========================
  // IMAGE UPLOAD
  // =========================

  Future<void> _pickAndUploadImage() async {
    if (widget.readOnly) return;

    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    await ApiClient.uploadSectionImage(
      widget.sessionId,
      widget.sectionKey,
      image,
    );

    widget.onUpdated();
  }

  // =========================
  // UI
  // =========================

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Row(
          children: [
            Expanded(
              child: Text(
                widget.sectionKey.replaceAll('_', ' ').toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (!widget.readOnly)
              IconButton(
                icon: const Icon(Icons.camera_alt, size: 18),
                onPressed: _pickAndUploadImage,
              ),
          ],
        ),
        subtitle: widget.readOnly
            ? const Text(
                'Read-only preview',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              )
            : const Text(
                'Long-press any field to edit',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: _buildSectionContent(),
          ),
          if (!widget.readOnly)
            Align(
              alignment: Alignment.centerRight,
              child: MicButton(
                isRecording: recording,
                onToggle: _toggleRecording,
              ),
            ),
        ],
      ),
    );
  }

  // =========================
  // CONTENT
  // =========================

  Widget _buildSectionContent() {
    final data = widget.sectionData;

    if (data == null) {
      return const Text(
        'No data yet.',
        style: TextStyle(color: Colors.grey),
      );
    }

    final List images =
        (data is Map && data['images'] is List) ? data['images'] : [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (images.isNotEmpty) _renderImages(images),
        _renderSectionBody(data),
      ],
    );
  }

  Widget _renderImages(List images) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: images.map<Widget>((img) {
          final filename = img['filename'];
          return GestureDetector(
            onTap: () => _showImagePreview(filename),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Image.network(
                '${ApiClient.baseUrl}/uploads/lab_reports/$filename',
                fit: BoxFit.cover,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showImagePreview(String filename) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: InteractiveViewer(
          child: Image.network(
            '${ApiClient.baseUrl}/uploads/lab_reports/$filename',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _renderSectionBody(dynamic data) {
    switch (widget.sectionKey) {
      case 'chief_complaint':
        return _renderChiefComplaint(data);
      case 'anamnesis':
        return _renderAnamnesis(data);
      case 'treatment_and_background':
        return _renderTreatment(data);
      case 'review_of_systems':
        return _renderReviewOfSystems(data);
      case 'past_medical_history':
        return _renderPastMedicalHistory(data);
      case 'assessment_and_plan':
        return _renderAssessmentPlan(data);
      default:
        return _renderKeyValueList(data);
    }
  }

  // =========================
  // RENDERERS
  // =========================

  Widget _renderChiefComplaint(Map data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _editable('Summary', data['summary'], 'chief_complaint.summary'),
        _editable('Duration', data['duration'], 'chief_complaint.duration'),
        _editableList(
          'Aggravating Factors',
          data['aggravating_factors'],
          'chief_complaint.aggravating_factors',
        ),
        _editableList(
          'Relieving Factors',
          data['relieving_factors'],
          'chief_complaint.relieving_factors',
        ),
        _editableList(
          'Functional Impact',
          data['functional_impact'],
          'chief_complaint.functional_impact',
        ),
      ],
    );
  }

  Widget _renderAnamnesis(Map data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _editable('Narrative', data['narrative'], 'anamnesis.narrative'),
        _editable(
          'Timeline Summary',
          data['timeline_summary'],
          'anamnesis.timeline_summary',
        ),
      ],
    );
  }

  Widget _renderTreatment(Map data) {
    final meds = data['current_medications'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (meds is List && meds.isNotEmpty)
          ...meds.map(
            (m) => Text(
              '• ${m['name']} ${m['dose'] ?? ''} ${m['frequency'] ?? ''}',
            ),
          ),
        _editable(
          'Allergies',
          data['allergic_anamnesis'],
          'treatment_and_background.allergic_anamnesis',
        ),
        _editable(
          'Injury History',
          data['injury_history'],
          'treatment_and_background.injury_history',
        ),
      ],
    );
  }

  Widget _renderReviewOfSystems(Map data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.entries.map((e) {
        final systemKey = e.key;
        final raw = e.value;

        List<String> present = [];
        List<String> absent = [];

        if (raw is Map) {
          if (raw['present'] is List) {
            present = List<String>.from(raw['present']);
          }
          if (raw['absent'] is List) {
            absent = List<String>.from(raw['absent']);
          }
        } else if (raw is List) {
          present = List<String>.from(raw);
        }

        if (present.isEmpty && absent.isEmpty) {
          return const SizedBox();
        }

        return GestureDetector(
          onLongPress: widget.readOnly
              ? null
              : () => _editField(
                    'review_of_systems.$systemKey',
                    [...present, ...absent].join(', '),
                  ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  systemKey.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (present.isNotEmpty)
                  Text('Present: ${present.join(', ')}'),
                if (absent.isNotEmpty)
                  Text('Absent: ${absent.join(', ')}'),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _renderPastMedicalHistory(Map data) {
    final conditions = data['known_conditions'];
    if (conditions is! List || conditions.isEmpty) {
      return const Text('No past medical history recorded.');
    }

    return GestureDetector(
      onLongPress: widget.readOnly
          ? null
          : () => _editField(
                'past_medical_history.known_conditions',
                conditions.toString(),
              ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: conditions.map<Widget>((c) {
          if (c is Map) {
            return Text('• ${c['name']} (${c['duration'] ?? 'unknown'})');
          }
          return Text('• $c');
        }).toList(),
      ),
    );
  }

  Widget _renderAssessmentPlan(Map data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _editable(
          'Provisional Diagnosis',
          data['provisional_diagnosis'],
          'assessment_and_plan.provisional_diagnosis',
        ),
        _editableList(
          'Investigations',
          data['investigations_advised'],
          'assessment_and_plan.investigations_advised',
        ),
        _editable(
          'Treatment',
          data['treatment_prescribed'],
          'assessment_and_plan.treatment_prescribed',
        ),
      ],
    );
  }

  // =========================
  // HELPERS
  // =========================

  Widget _editable(String label, dynamic value, String fieldPath) {
    if (value == null || value.toString().isEmpty) return const SizedBox();

    return GestureDetector(
      onLongPress:
          widget.readOnly ? null : () => _editField(fieldPath, value.toString()),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text('$label: $value'),
      ),
    );
  }

  Widget _editableList(String label, dynamic value, String fieldPath) {
    if (value is! List || value.isEmpty) return const SizedBox();

    return GestureDetector(
      onLongPress:
          widget.readOnly ? null : () => _editField(fieldPath, value.join(', ')),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text('$label: ${value.join(', ')}'),
      ),
    );
  }

  Widget _renderKeyValueList(Map data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.entries
          .where((e) => e.value != null)
          .map((e) => Text('${e.key}: ${e.value}'))
          .toList(),
    );
  }
}
