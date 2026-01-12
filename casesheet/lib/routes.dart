import 'package:flutter/material.dart';

import 'features/session/start_session_page.dart';
import 'features/session/recording_page.dart';
import 'features/session/fact_review_page.dart';
import 'features/session/finalize_page.dart';

class Routes {
  static const startSession = '/';
  static const recording = '/recording';
  static const factReview = '/fact-review';
  static const finalize = '/finalize';

  static Map<String, WidgetBuilder> get map => {
    // Start consultation
    startSession: (_) => const StartSessionPage(),

    // Recording page (requires sessionId)
    recording: (context) {
      final sessionId = ModalRoute.of(context)!.settings.arguments as String;
      return RecordingPage(sessionId: sessionId);
    },

    // Fact review page (requires sessionId)
    factReview: (context) {
      final sessionId = ModalRoute.of(context)!.settings.arguments as String;
      return FactReviewPage(sessionId: sessionId);
    },

    // Finalize page (requires sessionId)
    finalize: (context) {
      final sessionId = ModalRoute.of(context)!.settings.arguments as String;
      return FinalizePage(sessionId: sessionId);
    },
  };
}
