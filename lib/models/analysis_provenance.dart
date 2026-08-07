/// Scientific origin of a value returned by an analysis pipeline.
enum AnalysisProvenance {
  measured('measured'),
  reconstructed('reconstructed'),
  modelEstimated('model-estimated'),
  aiInferred('AI-inferred'),
  unknown('unknown');

  const AnalysisProvenance(this.apiValue);

  final String apiValue;

  static AnalysisProvenance fromApiValue(Object? value) {
    for (final provenance in values) {
      if (provenance.apiValue == value) {
        return provenance;
      }
    }

    return AnalysisProvenance.unknown;
  }
}
