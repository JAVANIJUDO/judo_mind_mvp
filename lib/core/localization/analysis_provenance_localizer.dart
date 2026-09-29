import '../../l10n/app_localizations.dart';
import '../../models/analysis_provenance.dart';

String localizeAnalysisProvenance(
  AppLocalizations l10n,
  AnalysisProvenance provenance,
) {
  return switch (provenance) {
    AnalysisProvenance.measured => l10n.provenanceMeasured,
    AnalysisProvenance.reconstructed => l10n.provenanceReconstructed,
    AnalysisProvenance.modelEstimated => l10n.provenanceModelEstimated,
    AnalysisProvenance.aiInferred => l10n.provenanceAiInferred,
    AnalysisProvenance.unknown => l10n.provenanceUnknown,
  };
}
