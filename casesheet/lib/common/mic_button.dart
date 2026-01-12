import 'package:flutter/material.dart';

class MicButton extends StatelessWidget {
  final bool isRecording;
  final VoidCallback onToggle;

  const MicButton({
    super.key,
    required this.isRecording,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 64,
      icon: Icon(
        isRecording ? Icons.stop_circle : Icons.mic,
        color: isRecording ? Colors.red : Colors.teal,
      ),
      onPressed: onToggle,
    );
  }
}
