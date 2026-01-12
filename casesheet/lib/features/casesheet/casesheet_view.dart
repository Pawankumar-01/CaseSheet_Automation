import 'package:flutter/material.dart';
import '../../models/casesheet.dart';
import '../../services/api_client.dart';
import '../../services/casesheet_mapper.dart';
import 'casesheet_section.dart';

class CaseSheetView extends StatefulWidget {
  final String sessionId;
  const CaseSheetView({super.key, required this.sessionId});

  @override
  State<CaseSheetView> createState() => _CaseSheetViewState();
}

class _CaseSheetViewState extends State<CaseSheetView> {
  CaseSheet? _sheet;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  Future<void> _loadDraft() async {
    try {
      final data = await ApiClient.fetchDraft(widget.sessionId);
      setState(() {
        _sheet = CaseSheetMapper.fromBackend(data);
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      debugPrint('Failed to load case sheet: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_sheet == null) {
      return const Center(child: Text('No case sheet data'));
    }

    return RefreshIndicator(
      onRefresh: _loadDraft,
      child: ListView(
        children: _sheet!.sections
            .map((section) => CaseSheetSection(section: section))
            .toList(),
      ),
    );
  }
}
