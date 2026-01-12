import 'dart:io'; // Required for File()
import 'package:record/record.dart';
import 'api_client.dart';
import 'package:path_provider/path_provider.dart'; // Required for path management

class AudioService {
  // In the latest 'record' package (v5+), use AudioRecorder instead of Record
  final AudioRecorder _recorder = AudioRecorder();
  String? _sessionId;

  void setSession(String sessionId) {
    _sessionId = sessionId;
  }

  Future<void> startRecording() async {
    // 1. Check permissions
    if (await _recorder.hasPermission()) {
      // 2. Get temporary directory to save the wav file
      final directory = await getTemporaryDirectory();
      final String path =
          '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.wav';

      // 3. Configure the recording settings
      const config = RecordConfig(
        encoder: AudioEncoder.wav,
        bitRate: 128000,
        sampleRate: 16000, // Whisper works best at 16k
        numChannels: 1, // Mono is better for transcription
      );

      // 4. Start recording to the file path
      await _recorder.start(config, path: path);
    }
  }

  Future<void> stopAndSendChunk() async {
    // Stop returns the path of the saved file
    final String? path = await _recorder.stop();

    if (path == null || _sessionId == null) {
      print("Recording failed or No Session ID");
      return;
    }

    try {
      final file = File(path);
      final bytes = await file.readAsBytes();

      // Send to your Gradio/FastAPI backend
      await ApiClient.uploadAudioChunk(_sessionId!, bytes);

      // Cleanup: Delete the temp file after sending to save space
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print("Error processing audio: $e");
    }
  }

  // Good practice to add a dispose method
  void dispose() {
    _recorder.dispose();
  }
}
