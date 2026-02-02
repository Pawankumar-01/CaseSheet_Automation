import 'dart:io';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'api_client.dart';

class AudioService {
  final AudioRecorder _recorder = AudioRecorder();

  String? _sessionId;
  String? _section;
  bool _isRecording = false;

  // --------------------
  // Session / Section
  // --------------------

  void setSession(String sessionId) {
    _sessionId = sessionId;
  }

  void setSection(String section) {
    _section = section;
  }

  // --------------------
  // Recording Controls
  // --------------------

  Future<void> startRecording() async {
    if (_isRecording) {
      print('[AUDIO] Already recording, ignoring start');
      return;
    }

    if (_sessionId == null || _section == null) {
      print('[AUDIO][ERROR] Session or Section not set');
      return;
    }

    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      print('[AUDIO][ERROR] Microphone permission denied');
      return;
    }

    final directory = await getTemporaryDirectory();
    final path =
        '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.wav';

    const config = RecordConfig(
      encoder: AudioEncoder.wav,
      bitRate: 128000,
      sampleRate: 16000,
      numChannels: 1,
    );

    await _recorder.start(config, path: path);
    _isRecording = true;

    print('[AUDIO] Recording started | section=$_section');
  }

  Future<void> stopAndSendChunk() async {
    if (!_isRecording) {
      print('[AUDIO] Not recording, ignoring stop');
      return;
    }

    final path = await _recorder.stop();
    _isRecording = false;

    if (path == null) {
      print('[AUDIO][ERROR] Recorder returned null path');
      return;
    }

    if (_sessionId == null || _section == null) {
      print('[AUDIO][ERROR] Session or Section missing on stop');
      return;
    }

    try {
      final file = File(path);
      final bytes = await file.readAsBytes();

      print(
        '[AUDIO] Uploading audio | session=$_sessionId | section=$_section | bytes=${bytes.length}',
      );

      await ApiClient.uploadAudioChunk(
        _sessionId!,
        _section!,
        bytes,
      );

      if (await file.exists()) {
        await file.delete();
      }

      print('[AUDIO] Upload complete & temp file deleted');
    } catch (e) {
      print('[AUDIO][ERROR] Failed to process audio: $e');
    }
  }

  // --------------------
  // Cleanup
  // --------------------

  void dispose() {
    _recorder.dispose();
  }
}
