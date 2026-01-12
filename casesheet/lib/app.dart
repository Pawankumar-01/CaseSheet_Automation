import 'package:flutter/material.dart';
import 'routes.dart';

class CaseSheetApp extends StatelessWidget {
  const CaseSheetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clinical Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      initialRoute: Routes.startSession,
      routes: Routes.map,
    );
  }
}
