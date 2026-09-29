import 'package:flutter/material.dart';

import '../../../../core/scientific_transparency/scientific_transparency_model.dart';
import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';
import '../../../../core/widgets/judo_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../technique_bottom_sheet.dart';

class ScientificStatusCard extends StatelessWidget {
  final ScientificTransparencySnapshot? snapshot;

  const ScientificStatusCard({super.key, required this.snapshot});

  ScientificTransparencySnapshot get _safeSnapshot {
    final value = snapshot;
    if (value == null || value.scientificApprovalIssued) {
      return ScientificTransparencySnapshot.failClosed;
    }
    return value;
  }

  Future<void> _openDetails(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return TechniqueBottomSheet.show<void>(
      context: context,
      title: l10n.scientificTransparencyDetailsTitle,
      icon: Icons.science_outlined,
      accentColor: JudoColors.warning,
      initialChildSize: 0.9,
      child: ScientificTransparencyDetails(snapshot: _safeSnapshot),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final effectiveSnapshot = _safeSnapshot;
    final isFailClosed = identical(
      effectiveSnapshot,
      ScientificTransparencySnapshot.failClosed,
    );

    return JudoCard(
      key: const ValueKey<String>('scientific-status-card'),
      borderColor: JudoColors.warning.withValues(alpha: 0.42),
      backgroundColor: JudoColors.warning.withValues(alpha: 0.06),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                label: l10n.scientificTransparencyStatusIconLabel,
                image: true,
                child: const Icon(
                  Icons.science_outlined,
                  color: JudoColors.warning,
                  size: JudoIconSize.md,
                ),
              ),
              const SizedBox(width: JudoSpacing.sm),
              Expanded(
                child: Text(
                  l10n.scientificTransparencyTitle,
                  style: JudoTypography.titleLarge.copyWith(
                    color: JudoColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: JudoSpacing.md),
          if (isFailClosed) ...[
            _SummaryLine(
              icon: Icons.lock_outline_rounded,
              text: l10n.scientificTransparencyNotReviewed,
            ),
            _SummaryLine(
              icon: Icons.lock_outline_rounded,
              text: l10n.scientificTransparencySensitiveLocked,
            ),
          ] else ...[
            _SummaryLine(
              icon: Icons.hourglass_top_rounded,
              text: l10n.scientificTransparencyHumanReviewPending,
            ),
            _SummaryLine(
              icon: Icons.gpp_maybe_outlined,
              text: l10n.scientificTransparencyNoApproval,
            ),
            _SummaryLine(
              icon: Icons.video_settings_outlined,
              text: l10n.scientificTransparencyVideoValidationOnly,
            ),
            _SummaryLine(
              icon: Icons.lock_outline_rounded,
              text: l10n.scientificTransparencySensitiveLocked,
            ),
          ],
          const SizedBox(height: JudoSpacing.sm),
          Semantics(
            button: true,
            label: l10n.scientificTransparencyViewDetails,
            child: TextButton.icon(
              key: const ValueKey<String>(
                'scientific-transparency-view-details',
              ),
              onPressed: () => _openDetails(context),
              icon: const Icon(Icons.arrow_forward_rounded),
              label: Text(l10n.scientificTransparencyViewDetails),
            ),
          ),
        ],
      ),
    );
  }
}

class ScientificTransparencyDetails extends StatelessWidget {
  final ScientificTransparencySnapshot? snapshot;

  const ScientificTransparencyDetails({super.key, required this.snapshot});

  ScientificTransparencySnapshot get _safeSnapshot {
    final value = snapshot;
    if (value == null || value.scientificApprovalIssued) {
      return ScientificTransparencySnapshot.failClosed;
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final effectiveSnapshot = _safeSnapshot;

    return Column(
      key: const ValueKey<String>('scientific-transparency-details'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DetailsSection(
          title: l10n.scientificTransparencyCurrentStatusSection,
          icon: Icons.science_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StatusRow(
                label: l10n.scientificTransparencyTitle,
                value: _statusLabel(l10n, effectiveSnapshot.scientificStatus),
              ),
              _StatusRow(
                label: l10n.scientificTransparencyHumanReviewLabel,
                value: _statusLabel(l10n, effectiveSnapshot.humanReviewState),
              ),
              _StatusRow(
                label: l10n.scientificTransparencyApprovalLabel,
                value: l10n.scientificTransparencyNoApproval,
              ),
            ],
          ),
        ),
        _DetailsSection(
          title: l10n.scientificTransparencyCandidateCoverageSection,
          icon: Icons.menu_book_outlined,
          child: effectiveSnapshot.candidateSources.isEmpty
              ? _BoundaryNotice(
                  key: const ValueKey<String>(
                    'scientific-transparency-sources-locked',
                  ),
                  text: l10n.scientificTransparencyMissingDataLocked,
                )
              : Column(
                  children: effectiveSnapshot.candidateSources
                      .map((source) => _CandidateSourceCard(source: source))
                      .toList(growable: false),
                ),
        ),
        _DetailsSection(
          title: l10n.scientificTransparencyHumanReviewSection,
          icon: Icons.fact_check_outlined,
          child: _BoundaryNotice(
            key: const ValueKey<String>(
              'scientific-transparency-human-review-boundary',
            ),
            text: effectiveSnapshot.candidateSources.isEmpty
                ? l10n.scientificTransparencyNotReviewed
                : l10n.scientificTransparencyHumanReviewDescription,
          ),
        ),
        _DetailsSection(
          title: l10n.scientificTransparencyCapabilityPanelTitle,
          icon: Icons.lock_person_outlined,
          child: effectiveSnapshot.capabilities.isEmpty
              ? _BoundaryNotice(
                  key: const ValueKey<String>(
                    'scientific-transparency-capabilities-locked',
                  ),
                  text: l10n.scientificTransparencyMissingDataLocked,
                )
              : Column(
                  key: const ValueKey<String>(
                    'scientific-transparency-capability-panel',
                  ),
                  children: effectiveSnapshot.capabilities
                      .map(
                        (capability) => _StatusRow(
                          label: _capabilityLabel(l10n, capability.displayKey),
                          value: _statusLabel(l10n, capability.state),
                        ),
                      )
                      .toList(growable: false),
                ),
        ),
        _DetailsSection(
          title: l10n.scientificTransparencyVideoLimitationsSection,
          icon: Icons.video_settings_outlined,
          child: _LimitationList(limitations: effectiveSnapshot.limitations),
        ),
        _DetailsSection(
          title: l10n.scientificTransparencySafetyBoundarySection,
          icon: Icons.health_and_safety_outlined,
          child: _BoundaryNotice(
            key: const ValueKey<String>(
              'scientific-transparency-safety-boundary',
            ),
            text: l10n.scientificTransparencySafetyBoundaryDescription,
          ),
        ),
        _DetailsSection(
          title: l10n.scientificTransparencyDoesNotDoSection,
          icon: Icons.block_outlined,
          child: _BoundaryNotice(
            key: const ValueKey<String>('scientific-transparency-does-not-do'),
            text: l10n.scientificTransparencyDoesNotDoDescription,
          ),
        ),
      ],
    );
  }
}

class _CandidateSourceCard extends StatelessWidget {
  final ScientificSourceDisplayItem source;

  const _CandidateSourceCard({required this.source});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(bottom: JudoSpacing.sm),
      child: JudoCard(
        borderColor: JudoColors.warning.withValues(alpha: 0.25),
        padding: const EdgeInsets.all(JudoSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: JudoSpacing.sm,
              runSpacing: JudoSpacing.xs,
              children: [
                _StatusPill(text: l10n.scientificTransparencyCandidateSource),
                _StatusPill(text: l10n.scientificTransparencyReviewPending),
              ],
            ),
            const SizedBox(height: JudoSpacing.sm),
            Text(source.title, style: JudoTypography.titleSmall),
            const SizedBox(height: JudoSpacing.xs),
            Text(
              '${source.year} · ${_sourceTypeLabel(l10n, source.sourceType)} · ${_accessLabel(l10n, source.accessState)}',
              style: JudoTypography.bodySmall.copyWith(
                color: JudoColors.textSecondary,
              ),
            ),
            const SizedBox(height: JudoSpacing.sm),
            Text(
              l10n.scientificTransparencyNotApprovedForClaim,
              style: JudoTypography.bodySmall.copyWith(
                color: JudoColors.warning,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LimitationList extends StatelessWidget {
  final List<ScientificLimitation> limitations;

  const _LimitationList({required this.limitations});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      key: const ValueKey<String>('scientific-transparency-limitations'),
      children: limitations
          .map(
            (limitation) => Padding(
              padding: const EdgeInsets.only(bottom: JudoSpacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Icon(
                      Icons.info_outline_rounded,
                      size: JudoIconSize.sm,
                      color: JudoColors.warning,
                    ),
                  ),
                  const SizedBox(width: JudoSpacing.sm),
                  Expanded(
                    child: Text(
                      _limitationLabel(l10n, limitation),
                      style: JudoTypography.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _DetailsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _DetailsSection({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: JudoSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: JudoColors.warning, size: JudoIconSize.sm),
              const SizedBox(width: JudoSpacing.sm),
              Expanded(child: Text(title, style: JudoTypography.titleLarge)),
            ],
          ),
          const SizedBox(height: JudoSpacing.md),
          child,
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _SummaryLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: JudoSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: JudoColors.warning, size: JudoIconSize.sm),
          const SizedBox(width: JudoSpacing.sm),
          Expanded(child: Text(text, style: JudoTypography.bodyMedium)),
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatusRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: JudoSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: JudoTypography.bodyMedium)),
          const SizedBox(width: JudoSpacing.md),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: JudoTypography.bodySmall.copyWith(
                color: JudoColors.warning,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String text;

  const _StatusPill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: JudoSpacing.sm,
        vertical: JudoSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: JudoColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(JudoRadius.sm),
      ),
      child: Text(
        text,
        style: JudoTypography.bodySmall.copyWith(color: JudoColors.warning),
      ),
    );
  }
}

class _BoundaryNotice extends StatelessWidget {
  final String text;

  const _BoundaryNotice({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return JudoCard(
      padding: const EdgeInsets.all(JudoSpacing.md),
      child: Text(text, style: JudoTypography.bodyMedium),
    );
  }
}

String _statusLabel(AppLocalizations l10n, ScientificTransparencyStatus state) {
  return switch (state) {
    ScientificTransparencyStatus.notScientificallyReviewed =>
      l10n.scientificTransparencyStatusNotReviewed,
    ScientificTransparencyStatus.humanReviewPending =>
      l10n.scientificTransparencyStatusHumanReviewPending,
    ScientificTransparencyStatus.reviewRequired =>
      l10n.scientificTransparencyStatusReviewRequired,
    ScientificTransparencyStatus.validationOnly =>
      l10n.scientificTransparencyStatusValidationOnly,
    ScientificTransparencyStatus.locked =>
      l10n.scientificTransparencyStatusLocked,
    ScientificTransparencyStatus.fullTextRequired =>
      l10n.scientificTransparencyStatusFullTextRequired,
    ScientificTransparencyStatus.methodBlocked =>
      l10n.scientificTransparencyStatusMethodBlocked,
    ScientificTransparencyStatus.sourceMappingRequired =>
      l10n.scientificTransparencyStatusSourceMappingRequired,
    ScientificTransparencyStatus.notApplicable =>
      l10n.scientificTransparencyStatusNotApplicable,
  };
}

String _sourceTypeLabel(
  AppLocalizations l10n,
  ScientificSourceType sourceType,
) {
  return switch (sourceType) {
    ScientificSourceType.consensusStatement =>
      l10n.scientificTransparencySourceTypeConsensus,
    ScientificSourceType.systematicReview =>
      l10n.scientificTransparencySourceTypeSystematicReview,
    ScientificSourceType.metaAnalysis =>
      l10n.scientificTransparencySourceTypeMetaAnalysis,
    ScientificSourceType.systematicReviewAndMetaAnalysis =>
      l10n.scientificTransparencySourceTypeSystematicReviewMetaAnalysis,
  };
}

String _accessLabel(
  AppLocalizations l10n,
  ScientificSourceAccessState accessState,
) {
  return switch (accessState) {
    ScientificSourceAccessState.publicFullTextIdentified =>
      l10n.scientificTransparencyAccessPublicFullText,
    ScientificSourceAccessState.validatedRepositoryPdf =>
      l10n.scientificTransparencyAccessValidatedRepository,
    ScientificSourceAccessState.validatedAcceptedManuscript =>
      l10n.scientificTransparencyAccessAcceptedManuscript,
    ScientificSourceAccessState.validatedPublisherVersion =>
      l10n.scientificTransparencyAccessPublisherVersion,
  };
}

String _capabilityLabel(AppLocalizations l10n, String displayKey) {
  return switch (displayKey) {
    'singleCameraPoseSummary' =>
      l10n.scientificTransparencyCapabilityPoseSummary,
    'reviewedSingleAttempt' =>
      l10n.scientificTransparencyCapabilityReviewedAttempt,
    'projectedTwoDimensionalMetrics' =>
      l10n.scientificTransparencyCapabilityProjectedMetrics,
    'projectedHipAngle' =>
      l10n.scientificTransparencyCapabilityProjectedHipAngle,
    'automaticIdentity' =>
      l10n.scientificTransparencyCapabilityAutomaticIdentity,
    'automaticPhases' => l10n.scientificTransparencyCapabilityAutomaticPhases,
    'threeDimensionalReconstruction' =>
      l10n.scientificTransparencyCapabilityThreeDimensional,
    'forceAndKinetics' => l10n.scientificTransparencyCapabilityForceKinetics,
    'trainingPrescription' =>
      l10n.scientificTransparencyCapabilityTrainingPrescription,
    _ => l10n.scientificTransparencyUnknownCapability,
  };
}

String _limitationLabel(
  AppLocalizations l10n,
  ScientificLimitation limitation,
) {
  return switch (limitation) {
    ScientificLimitation.engineeringObservationsOnly =>
      l10n.scientificTransparencyLimitationEngineering,
    ScientificLimitation.noDirectForceOrKinetics =>
      l10n.scientificTransparencyLimitationNoForce,
    ScientificLimitation.noDefinitiveThreeDimensionalAnalysis =>
      l10n.scientificTransparencyLimitationNoThreeDimensional,
    ScientificLimitation.noTechnicalErrorOrInjuryDiagnosis =>
      l10n.scientificTransparencyLimitationNoDiagnosis,
    ScientificLimitation.noInjuryPrediction =>
      l10n.scientificTransparencyLimitationNoInjuryPrediction,
    ScientificLimitation.noRefereeDecision =>
      l10n.scientificTransparencyLimitationNoReferee,
    ScientificLimitation.associationIsNotCausation =>
      l10n.scientificTransparencyLimitationAssociation,
    ScientificLimitation.riskIsNotCertainPrediction =>
      l10n.scientificTransparencyLimitationRisk,
    ScientificLimitation.missingEvidenceKeepsFeaturesLocked =>
      l10n.scientificTransparencyLimitationMissingEvidence,
  };
}
