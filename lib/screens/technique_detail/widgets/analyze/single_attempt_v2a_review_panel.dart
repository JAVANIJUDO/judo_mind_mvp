import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../core/ai/analysis/grounded_sensei_service.dart';
import '../../../../core/ai/analysis/single_attempt_v2a_service.dart';
import '../../../../core/providers/local_attempt_history_provider.dart';
import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';
import '../../../../data/ai/local_grounded_sensei_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/grounded_sensei.dart';
import '../../../../models/single_attempt_analysis_v2a.dart';
import '../../../../models/single_attempt_v2a_request.dart';
import '../../../../models/technique_model.dart';
import 'grounded_sensei_explanation_card.dart';
import 'single_attempt_v2a_result_card.dart';

class SingleAttemptV2AReviewPanel extends StatefulWidget {
  const SingleAttemptV2AReviewPanel({
    super.key,
    required this.videoPath,
    required this.videoId,
    required this.cameraView,
    required this.service,
    required this.technique,
    this.groundedSenseiService,
    this.onResult,
  });

  final String videoPath;
  final String videoId;
  final String cameraView;
  final SingleAttemptV2AService service;
  final TechniqueModel technique;
  final GroundedSenseiService? groundedSenseiService;
  final ValueChanged<SingleAttemptAnalysisV2A>? onResult;

  @override
  State<SingleAttemptV2AReviewPanel> createState() =>
      _SingleAttemptV2AReviewPanelState();
}

class _SingleAttemptV2AReviewPanelState
    extends State<SingleAttemptV2AReviewPanel> {
  static const _eventSchemaId = 'human-single-attempt-boundaries-v1';

  final _formKey = GlobalKey<FormState>();
  final _attemptStartFrame = TextEditingController();
  final _attemptStartTimestamp = TextEditingController();
  final _attemptEndFrame = TextEditingController();
  final _attemptEndTimestamp = TextEditingController();
  final _angleFrame = TextEditingController();
  final _angleTimestamp = TextEditingController();
  final _neutralTrack = TextEditingController();
  final _detectionIndex = TextEditingController();
  final _angleEventLabel = TextEditingController();

  ReviewedSupportLeg? _supportLeg;
  ReviewedAttackingLeg? _attackingLeg;
  bool? _projectedAngleViewSuitable;
  bool? _lowRollConfirmed;
  bool _isSubmitting = false;
  String? _error;
  SingleAttemptAnalysisV2A? _result;
  GroundedSenseiExplanation? _groundedExplanation;
  bool _groundedSenseiUnavailable = false;

  @override
  void dispose() {
    _attemptStartFrame.dispose();
    _attemptStartTimestamp.dispose();
    _attemptEndFrame.dispose();
    _attemptEndTimestamp.dispose();
    _angleFrame.dispose();
    _angleTimestamp.dispose();
    _neutralTrack.dispose();
    _detectionIndex.dispose();
    _angleEventLabel.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final formIsValid = _formKey.currentState?.validate() ?? false;

    if (!formIsValid ||
        _supportLeg == null ||
        _attackingLeg == null ||
        _projectedAngleViewSuitable == null ||
        _lowRollConfirmed == null) {
      setState(() {
        _error = l10n.reviewedInputRequired;
        _result = null;
        _groundedExplanation = null;
        _groundedSenseiUnavailable = false;
      });
      return;
    }

    final request = SingleAttemptV2ARequest(
      videoPath: widget.videoPath,
      videoId: widget.videoId,
      cameraView: widget.cameraView,
      attemptStart: ReviewedFrameReference(
        frameIndex: int.parse(_attemptStartFrame.text),
        timestampMs: int.parse(_attemptStartTimestamp.text),
      ),
      attemptEnd: ReviewedFrameReference(
        frameIndex: int.parse(_attemptEndFrame.text),
        timestampMs: int.parse(_attemptEndTimestamp.text),
      ),
      eventSchemaId: _eventSchemaId,
      neutralTrackId: _neutralTrack.text.trim(),
      selectedDetectionIndex: int.parse(_detectionIndex.text),
      supportLeg: _supportLeg!,
      attackingLeg: _attackingLeg!,
      angleFrame: ReviewedFrameReference(
        frameIndex: int.parse(_angleFrame.text),
        timestampMs: int.parse(_angleTimestamp.text),
      ),
      angleEventLabel: _angleEventLabel.text.trim(),
      projectedAngleViewSuitable: _projectedAngleViewSuitable!,
      lowRollConfirmed: _lowRollConfirmed!,
    );

    if (!request.isValid) {
      setState(() {
        _error = l10n.reviewedInputSequenceInvalid;
        _result = null;
        _groundedExplanation = null;
        _groundedSenseiUnavailable = false;
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _error = null;
      _result = null;
      _groundedExplanation = null;
      _groundedSenseiUnavailable = false;
    });

    try {
      final result = await widget.service.analyzeReviewedVideo(request);
      if (!mounted) {
        return;
      }
      context.read<LocalAttemptHistoryProvider>().prepareResult(
        result.analysisId,
      );
      setState(() {
        _result = result;
      });
      widget.onResult?.call(result);

      try {
        final explanation =
            await (widget.groundedSenseiService ??
                    const LocalGroundedSenseiService())
                .explain(
                  GroundedSenseiRequest(
                    technique: widget.technique,
                    reviewedRequest: request,
                    reviewedResult: result,
                    locale: Localizations.localeOf(context).languageCode,
                  ),
                );
        if (!mounted) {
          return;
        }
        setState(() {
          _groundedExplanation = explanation;
          _groundedSenseiUnavailable = false;
        });
      } on GroundedSenseiException {
        if (!mounted) {
          return;
        }
        setState(() {
          _groundedExplanation = null;
          _groundedSenseiUnavailable = true;
        });
      } catch (_) {
        if (!mounted) {
          return;
        }
        setState(() {
          _groundedExplanation = null;
          _groundedSenseiUnavailable = true;
        });
      }
    } on SingleAttemptV2AException catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = error.message;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = l10n.reviewedAnalysisFailed;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      key: const ValueKey('single-attempt-v2a-review-panel'),
      width: double.infinity,
      padding: const EdgeInsets.all(JudoSpacing.lg),
      decoration: BoxDecoration(
        color: JudoColors.surface,
        borderRadius: BorderRadius.circular(JudoRadius.lg),
        border: Border.all(color: JudoColors.primary.withValues(alpha: 0.55)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.reviewedWorkflowTitle, style: JudoTypography.titleLarge),
            const SizedBox(height: JudoSpacing.xs),
            Text(
              l10n.reviewedWorkflowDescription,
              style: JudoTypography.bodySmall.copyWith(
                color: JudoColors.textSecondary,
              ),
            ),
            const SizedBox(height: JudoSpacing.sm),
            Text(
              '${l10n.reviewedEventSchema}: $_eventSchemaId',
              style: JudoTypography.bodySmall.copyWith(
                color: JudoColors.primary,
              ),
            ),
            const SizedBox(height: JudoSpacing.lg),
            LayoutBuilder(
              builder: (context, constraints) {
                final fieldWidth = constraints.maxWidth >= 620
                    ? (constraints.maxWidth - JudoSpacing.md) / 2
                    : constraints.maxWidth;
                return Wrap(
                  spacing: JudoSpacing.md,
                  runSpacing: JudoSpacing.md,
                  children: [
                    _integerField(
                      width: fieldWidth,
                      controller: _attemptStartFrame,
                      label: l10n.reviewedAttemptStartFrame,
                      key: const ValueKey('reviewed-attempt-start-frame'),
                    ),
                    _integerField(
                      width: fieldWidth,
                      controller: _attemptStartTimestamp,
                      label: l10n.reviewedAttemptStartTimestamp,
                      key: const ValueKey('reviewed-attempt-start-timestamp'),
                    ),
                    _integerField(
                      width: fieldWidth,
                      controller: _attemptEndFrame,
                      label: l10n.reviewedAttemptEndFrame,
                      key: const ValueKey('reviewed-attempt-end-frame'),
                    ),
                    _integerField(
                      width: fieldWidth,
                      controller: _attemptEndTimestamp,
                      label: l10n.reviewedAttemptEndTimestamp,
                      key: const ValueKey('reviewed-attempt-end-timestamp'),
                    ),
                    _integerField(
                      width: fieldWidth,
                      controller: _angleFrame,
                      label: l10n.reviewedAngleFrame,
                      key: const ValueKey('reviewed-angle-frame'),
                    ),
                    _integerField(
                      width: fieldWidth,
                      controller: _angleTimestamp,
                      label: l10n.reviewedAngleTimestamp,
                      key: const ValueKey('reviewed-angle-timestamp'),
                    ),
                    SizedBox(
                      width: fieldWidth,
                      child: TextFormField(
                        key: const ValueKey('reviewed-neutral-track'),
                        controller: _neutralTrack,
                        decoration: InputDecoration(
                          labelText: l10n.reviewedNeutralTrack,
                        ),
                        validator: (value) {
                          final track = value?.trim() ?? '';
                          if (track.isEmpty) {
                            return l10n.reviewedInputRequired;
                          }
                          if (!RegExp(r'^Track [A-Z]+$').hasMatch(track) ||
                              track == 'Track TORI' ||
                              track == 'Track UKE') {
                            return l10n.reviewedNeutralTrackInvalid;
                          }
                          return null;
                        },
                      ),
                    ),
                    _integerField(
                      width: fieldWidth,
                      controller: _detectionIndex,
                      label: l10n.reviewedDetectionIndex,
                      key: const ValueKey('reviewed-detection-index'),
                    ),
                    SizedBox(
                      width: fieldWidth,
                      child: DropdownButtonFormField<ReviewedSupportLeg>(
                        key: const ValueKey('reviewed-support-leg'),
                        initialValue: _supportLeg,
                        decoration: InputDecoration(
                          labelText: l10n.reviewedSupportLeg,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: ReviewedSupportLeg.left,
                            child: Text(l10n.leftSide),
                          ),
                          DropdownMenuItem(
                            value: ReviewedSupportLeg.right,
                            child: Text(l10n.rightSide),
                          ),
                        ],
                        onChanged: (value) => setState(() {
                          _supportLeg = value;
                        }),
                        validator: (value) =>
                            value == null ? l10n.reviewedInputRequired : null,
                      ),
                    ),
                    SizedBox(
                      width: fieldWidth,
                      child: DropdownButtonFormField<ReviewedAttackingLeg>(
                        key: const ValueKey('reviewed-attacking-leg'),
                        initialValue: _attackingLeg,
                        decoration: InputDecoration(
                          labelText: l10n.reviewedAttackingLeg,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: ReviewedAttackingLeg.left,
                            child: Text(l10n.leftSide),
                          ),
                          DropdownMenuItem(
                            value: ReviewedAttackingLeg.right,
                            child: Text(l10n.rightSide),
                          ),
                        ],
                        onChanged: (value) => setState(() {
                          _attackingLeg = value;
                        }),
                        validator: (value) =>
                            value == null ? l10n.reviewedInputRequired : null,
                      ),
                    ),
                    SizedBox(
                      width: fieldWidth,
                      child: TextFormField(
                        key: const ValueKey('reviewed-angle-event-label'),
                        controller: _angleEventLabel,
                        decoration: InputDecoration(
                          labelText: l10n.reviewedAngleEventLabel,
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? l10n.reviewedInputRequired
                            : null,
                      ),
                    ),
                    _reviewedBoolField(
                      width: fieldWidth,
                      key: const ValueKey('reviewed-view-suitable'),
                      label: l10n.reviewedProjectedViewSuitable,
                      value: _projectedAngleViewSuitable,
                      onChanged: (value) => setState(() {
                        _projectedAngleViewSuitable = value;
                      }),
                    ),
                    _reviewedBoolField(
                      width: fieldWidth,
                      key: const ValueKey('reviewed-low-roll'),
                      label: l10n.reviewedLowRoll,
                      value: _lowRollConfirmed,
                      onChanged: (value) => setState(() {
                        _lowRollConfirmed = value;
                      }),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: JudoSpacing.lg),
            Text(
              l10n.reviewedHumanGateNotice,
              style: JudoTypography.bodySmall.copyWith(
                color: JudoColors.warning,
              ),
            ),
            const SizedBox(height: JudoSpacing.md),
            SizedBox(
              width: double.infinity,
              height: JudoButtonHeight.large,
              child: ElevatedButton.icon(
                key: const ValueKey('run-reviewed-v2a'),
                onPressed: _isSubmitting ? null : _submit,
                icon: _isSubmitting
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.fact_check_outlined),
                label: Text(
                  _isSubmitting
                      ? l10n.reviewedAnalysisRunning
                      : l10n.runReviewedAnalysis,
                ),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: JudoSpacing.md),
              Text(
                _error!,
                key: const ValueKey('reviewed-v2a-error'),
                style: JudoTypography.bodySmall.copyWith(
                  color: JudoColors.danger,
                ),
              ),
            ],
            if (_result != null) ...[
              const SizedBox(height: JudoSpacing.xl),
              SingleAttemptV2AResultCard(result: _result!),
              if (_groundedExplanation != null) ...[
                const SizedBox(height: JudoSpacing.lg),
                GroundedSenseiExplanationCard(
                  explanation: _groundedExplanation!,
                ),
              ] else if (_groundedSenseiUnavailable) ...[
                const SizedBox(height: JudoSpacing.lg),
                Container(
                  key: const ValueKey('grounded-sensei-unavailable'),
                  width: double.infinity,
                  padding: const EdgeInsets.all(JudoSpacing.md),
                  decoration: BoxDecoration(
                    color: JudoColors.warning.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(JudoRadius.md),
                  ),
                  child: Text(
                    l10n.groundedSenseiUnavailable,
                    style: JudoTypography.bodySmall.copyWith(
                      color: JudoColors.warning,
                    ),
                  ),
                ),
              ],
              if (_result!.hasExpectedScientificBoundary) ...[
                const SizedBox(height: JudoSpacing.lg),
                _buildLocalSaveAction(_result!, l10n),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLocalSaveAction(
    SingleAttemptAnalysisV2A result,
    AppLocalizations l10n,
  ) {
    return Consumer<LocalAttemptHistoryProvider>(
      builder: (context, history, child) {
        final completed =
            history.saveState == LocalAttemptSaveState.saved ||
            history.saveState == LocalAttemptSaveState.alreadySaved;
        final label = switch (history.saveState) {
          LocalAttemptSaveState.idle => l10n.saveAttemptLocally,
          LocalAttemptSaveState.saving => l10n.savingAttemptLocally,
          LocalAttemptSaveState.saved => l10n.attemptSavedOnDevice,
          LocalAttemptSaveState.alreadySaved => l10n.attemptAlreadySaved,
          LocalAttemptSaveState.failure => l10n.attemptSaveFailed,
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: JudoButtonHeight.large,
              child: OutlinedButton.icon(
                key: const ValueKey('save-v2a-attempt-locally'),
                onPressed: history.isSaving || completed
                    ? null
                    : () => history.save(result),
                icon: history.isSaving
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        completed
                            ? Icons.check_circle_outline
                            : Icons.save_alt_outlined,
                      ),
                label: Text(label),
              ),
            ),
            const SizedBox(height: JudoSpacing.sm),
            Text(
              l10n.localAttemptStorageDisclosure,
              key: const ValueKey('local-attempt-storage-disclosure'),
              style: JudoTypography.bodySmall.copyWith(
                color: JudoColors.textSecondary,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _integerField({
    required double width,
    required TextEditingController controller,
    required String label,
    Key? key,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: width,
      child: TextFormField(
        key: key,
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(labelText: label),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return l10n.reviewedInputRequired;
          }
          final parsed = int.tryParse(value);
          if (parsed == null || parsed < 0) {
            return l10n.reviewedNonNegativeInteger;
          }
          return null;
        },
      ),
    );
  }

  Widget _reviewedBoolField({
    required double width,
    required Key key,
    required String label,
    required bool? value,
    required ValueChanged<bool?> onChanged,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<bool>(
        key: key,
        initialValue: value,
        decoration: InputDecoration(labelText: label),
        items: [
          DropdownMenuItem(value: true, child: Text(l10n.reviewedYes)),
          DropdownMenuItem(value: false, child: Text(l10n.reviewedNo)),
        ],
        onChanged: onChanged,
        validator: (selected) =>
            selected == null ? l10n.reviewedInputRequired : null,
      ),
    );
  }
}
