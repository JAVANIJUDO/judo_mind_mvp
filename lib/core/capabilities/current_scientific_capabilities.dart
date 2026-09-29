import '../../models/single_attempt_analysis_v2a.dart';

/// Product-facing scientific boundaries sourced from the validated V2A
/// contract. This contains no metric formulas and grants no new capability.
class CurrentScientificCapabilities {
  const CurrentScientificCapabilities._();

  static const String approvedTechniqueId = 'uchi-mata';
  static Set<String> get approvedMetricIds =>
      Set.unmodifiable(SingleAttemptAnalysisV2A.requiredMetricIds);

  static const bool reviewRequiredAutoPromotion = false;
  static const String multiPersonEvidenceStatus = 'insufficient';
  static const bool interactionMetricsReportable = false;
}
