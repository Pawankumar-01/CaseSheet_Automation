class ClinicalFact {
  final String factId;
  final String intent;
  final String factType;
  String name;
  String status;
  String? severity;
  String? duration;
  double confidence;

  ClinicalFact({
    required this.factId,
    required this.intent,
    required this.factType,
    required this.name,
    required this.status,
    this.severity,
    this.duration,
    required this.confidence,
  });

  factory ClinicalFact.fromJson(Map<String, dynamic> json) {
    return ClinicalFact(
      factId: json['fact_id'],
      intent: json['intent'],
      factType: json['fact_type'],
      name: json['name'],
      status: json['status'],
      severity: json['severity'],
      duration: json['duration'],
      confidence: (json['confidence'] ?? 0.0).toDouble(),
    );
  }
}
