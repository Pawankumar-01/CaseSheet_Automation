import 'package:flutter/material.dart';

class LoadingState extends StatelessWidget {
  final String message;
  const LoadingState({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
