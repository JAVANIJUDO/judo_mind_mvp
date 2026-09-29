import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/ai/analysis/grounded_sensei_service.dart';
import '../../../../core/ai/analysis/guided_single_attempt_v2a_service.dart';
import '../../../../core/providers/local_attempt_history_provider.dart';
import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';
import '../../../../data/ai/local_grounded_sensei_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/grounded_sensei.dart';
import '../../../../models/guided_single_attempt_review.dart';
import '../../../../models/single_attempt_analysis_v2a.dart';
import '../../../../models/single_attempt_v2a_request.dart';
import '../../../../models/technique_model.dart';
import 'grounded_sensei_explanation_card.dart';
import 'single_attempt_v2a_result_card.dart';

enum _ReviewAnswer { yes, no, notSure }

class GuidedSingleAttemptReviewPanel extends StatefulWidget {
  const GuidedSingleAttemptReviewPanel({
    super.key,
    required this.videoPath,
    required this.videoId,
    required this.cameraView,
    required this.videoDuration,
    required this.technique,
    required this.service,
    this.onPreviewMoment,
    this.groundedSenseiService,
  });

  final String videoPath;
  final String videoId;
  final String cameraView;
  final Duration videoDuration;
  final TechniqueModel technique;
  final GuidedSingleAttemptV2AService service;
  final ValueChanged<Duration>? onPreviewMoment;
  final GroundedSenseiService? groundedSenseiService;

  @override
  State<GuidedSingleAttemptReviewPanel> createState() =>
      _GuidedSingleAttemptReviewPanelState();
}

class _GuidedSingleAttemptReviewPanelState
    extends State<GuidedSingleAttemptReviewPanel> {
  GuidedTimingManifest? _manifest;
  SourceTimingState? _sourceTiming;
  int _startFrame = 0;
  int _endFrame = 1;
  int _momentFrame = 0;
  bool _boundariesConfirmed = false;
  bool _singleAttemptConfirmed = false;
  GuidedBoundaryPreview? _boundaryPreview;
  GuidedReviewPrepareRequest? _preparedRequest;
  GuidedReviewSession? _session;
  String? _candidateToken;
  bool _toriConfirmed = false;
  bool _reviewerUncertain = false;
  ReviewedSupportLeg? _supportLeg;
  ReviewedAttackingLeg? _attackingLeg;
  _ReviewAnswer? _viewSuitable;
  _ReviewAnswer? _lowRoll;
  bool _busy = false;
  String? _error;
  SingleAttemptAnalysisV2A? _result;
  GroundedSenseiExplanation? _explanation;
  bool _senseiUnavailable = false;
  int _contextRevision = 0;

  @override
  void initState() {
    super.initState();
    _resetTimeline();
  }

  @override
  void didUpdateWidget(covariant GuidedSingleAttemptReviewPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoId != widget.videoId ||
        oldWidget.videoPath != widget.videoPath ||
        oldWidget.cameraView != widget.cameraView ||
        oldWidget.videoDuration != widget.videoDuration ||
        oldWidget.technique.id != widget.technique.id) {
      _resetTimeline();
    }
  }

  void _resetHumanReview() {
    _candidateToken = null;
    _toriConfirmed = false;
    _reviewerUncertain = false;
    _supportLeg = null;
    _attackingLeg = null;
    _viewSuitable = null;
    _lowRoll = null;
  }

  void _clearAnalysisOutcome() {
    _result = null;
    _explanation = null;
    _senseiUnavailable = false;
  }

  void _invalidatePreparedAttempt() {
    _boundariesConfirmed = false;
    _singleAttemptConfirmed = false;
    _boundaryPreview = null;
    _preparedRequest = null;
    _session = null;
    _resetHumanReview();
    _clearAnalysisOutcome();
    _error = null;
  }

  void _resetTimeline() {
    _contextRevision += 1;
    _manifest = null;
    _sourceTiming = null;
    _startFrame = 0;
    _endFrame = 1;
    _momentFrame = 0;
    _invalidatePreparedAttempt();
  }

  void _editAttemptBoundaries() {
    setState(() {
      _contextRevision += 1;
      _invalidatePreparedAttempt();
    });
  }

  void _humanReviewChanged(VoidCallback change) {
    setState(() {
      change();
      _clearAnalysisOutcome();
      _error = null;
    });
  }

  bool get _canAnalyze =>
      _session != null &&
      _session!.hasReadyCandidateEvidence &&
      _preparedRequest != null &&
      _candidateToken != null &&
      _toriConfirmed &&
      _supportLeg != null &&
      _attackingLeg != null &&
      _viewSuitable != null &&
      _lowRoll != null &&
      _viewSuitable != _ReviewAnswer.notSure &&
      _lowRoll != _ReviewAnswer.notSure &&
      !_reviewerUncertain;

  String _time(double milliseconds) {
    final duration = Duration(milliseconds: milliseconds.round());
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final tenths = (duration.inMilliseconds.remainder(1000) ~/ 100);
    return '${duration.inMinutes}:$seconds.$tenths';
  }

  String _localizedTechniqueName() {
    final language = Localizations.localeOf(context).languageCode;
    for (final translation in widget.technique.translations) {
      if (translation.languageCode == language && translation.name.isNotEmpty) {
        return translation.name;
      }
    }
    return widget.technique.nameEn;
  }

  String _candidateVisibilityText(
    AppLocalizations l10n,
    GuidedReviewCandidate candidate,
  ) => switch (candidate.modelLandmarkVisibilityStatus) {
    GuidedModelLandmarkVisibilityStatus.available =>
      l10n.guidedCandidateVisibilityAvailable(
        candidate.modelLandmarkVisibilityCount,
        candidate.requiredLandmarkCount,
      ),
    GuidedModelLandmarkVisibilityStatus.partial =>
      l10n.guidedCandidateVisibilityPartial(
        candidate.modelLandmarkVisibilityCount,
        candidate.requiredLandmarkCount,
      ),
    GuidedModelLandmarkVisibilityStatus.unavailable =>
      l10n.guidedCandidateVisibilityUnavailable,
  };

  Widget _candidateEvidenceStatus(
    AppLocalizations l10n,
    GuidedReviewSession session,
  ) {
    if (session.hasReadyCandidateEvidence) {
      return Text(
        l10n.guidedCandidateEvidenceReady,
        key: const ValueKey('guided-ready-candidate-evidence'),
      );
    }

    final insufficient =
        session.candidateSelectionStatus ==
        GuidedCandidateSelectionStatus.insufficientCandidateEvidence;
    final message = insufficient
        ? l10n.guidedCandidateEvidenceInsufficient(
            session.detectedPoseCount,
            session.selectableCandidateCount,
          )
        : l10n.guidedNoSelectableCandidateEvidence(session.detectedPoseCount);
    return Semantics(
      liveRegion: true,
      child: Container(
        key: ValueKey(
          insufficient
              ? 'guided-insufficient-candidate-evidence'
              : 'guided-no-selectable-candidate',
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(JudoSpacing.sm),
        decoration: BoxDecoration(
          color: JudoColors.warning.withValues(alpha: .12),
          border: Border.all(color: JudoColors.warning),
          borderRadius: BorderRadius.circular(JudoRadius.sm),
        ),
        child: Text(
          message,
          style: JudoTypography.bodySmall.copyWith(color: JudoColors.warning),
        ),
      ),
    );
  }

  void _seekFrame(int frame) {
    final manifest = _manifest;
    if (manifest == null) return;
    widget.onPreviewMoment?.call(
      Duration(milliseconds: manifest.timestampForFrame(frame)),
    );
  }

  Future<void> _loadTimingManifest() async {
    final l10n = AppLocalizations.of(context)!;
    final sourceTiming = _sourceTiming;
    if (sourceTiming == null ||
        sourceTiming == SourceTimingState.knownTimeScale) {
      setState(() => _error = l10n.guidedSourceTimingRequired);
      return;
    }
    final revision = _contextRevision + 1;
    setState(() {
      _contextRevision = revision;
      _invalidatePreparedAttempt();
      _busy = true;
    });
    try {
      final manifest = await widget.service.prepareTimingManifest(
        GuidedTimingManifestRequest(
          videoPath: widget.videoPath,
          videoId: widget.videoId,
          sourceTimingState: sourceTiming,
        ),
      );
      if (!mounted || revision != _contextRevision) return;
      setState(() {
        _manifest = manifest;
        _startFrame = 0;
        _endFrame = manifest.totalDecodedFrames - 1;
        _momentFrame = _endFrame ~/ 2;
      });
    } on GuidedReviewException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) setState(() => _error = l10n.guidedReviewBackendError);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  GuidedReviewPrepareRequest _boundaryRequest({required bool confirmed}) {
    final manifest = _manifest!;
    return GuidedReviewPrepareRequest(
      videoPath: widget.videoPath,
      videoId: widget.videoId,
      techniqueId: widget.technique.id == '001'
          ? 'uchi-mata'
          : widget.technique.id,
      cameraView: widget.cameraView,
      timingManifestId: manifest.id,
      attemptStartFrame: _startFrame,
      attemptEndFrame: _endFrame,
      reviewFrame: _momentFrame,
      boundariesConfirmed: confirmed,
      singleAttemptConfirmed: confirmed && _singleAttemptConfirmed,
    );
  }

  Future<void> _reviewBoundaries() async {
    final l10n = AppLocalizations.of(context)!;
    if (_manifest == null || _endFrame <= _startFrame) {
      setState(() => _error = l10n.guidedReviewBoundaryError);
      return;
    }
    final revision = _contextRevision + 1;
    setState(() {
      _contextRevision = revision;
      _invalidatePreparedAttempt();
      _busy = true;
    });
    try {
      final preview = await widget.service.previewBoundaries(
        _boundaryRequest(confirmed: false),
      );
      if (!mounted || revision != _contextRevision) return;
      setState(() => _boundaryPreview = preview);
    } on GuidedReviewException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) setState(() => _error = l10n.guidedReviewBackendError);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _prepare() async {
    final l10n = AppLocalizations.of(context)!;
    final manifest = _manifest;
    if (manifest == null ||
        !_boundariesConfirmed ||
        !_singleAttemptConfirmed ||
        _endFrame <= _startFrame ||
        _momentFrame < _startFrame ||
        _momentFrame > _endFrame) {
      setState(() => _error = l10n.guidedReviewBoundaryError);
      return;
    }
    final request = _boundaryRequest(confirmed: true);
    final revision = _contextRevision + 1;
    setState(() {
      _contextRevision = revision;
      _busy = true;
      _error = null;
      _clearAnalysisOutcome();
    });
    try {
      final session = await widget.service.prepare(request);
      if (!mounted || revision != _contextRevision) return;
      setState(() {
        _preparedRequest = request;
        _session = session;
        _resetHumanReview();
      });
    } on GuidedReviewException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) setState(() => _error = l10n.guidedReviewBackendError);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _analyze() async {
    final l10n = AppLocalizations.of(context)!;
    final session = _session;
    final prepared = _preparedRequest;
    if (session == null || prepared == null || !_canAnalyze) {
      setState(() => _error = l10n.guidedReviewUncertainWithheld);
      return;
    }
    final revision = _contextRevision;
    setState(() {
      _busy = true;
      _error = null;
      _clearAnalysisOutcome();
    });
    try {
      final analysis = await widget.service.analyze(
        prepared,
        GuidedReviewConfirmation(
          session: session,
          roleAssignment: GuidedHumanRoleAssignment(
            candidateToken: _candidateToken!,
          ),
          toriConfirmed: true,
          supportLeg: _supportLeg!,
          attackingLeg: _attackingLeg!,
          projectedAngleViewSuitable: _viewSuitable == _ReviewAnswer.yes,
          lowRollConfirmed: _lowRoll == _ReviewAnswer.yes,
          reviewerUncertain: false,
        ),
      );
      if (!mounted || revision != _contextRevision) return;
      context.read<LocalAttemptHistoryProvider>().prepareResult(
        analysis.result.analysisId,
      );
      setState(() => _result = analysis.result);
      try {
        final explanation =
            await (widget.groundedSenseiService ??
                    const LocalGroundedSenseiService())
                .explain(
                  GroundedSenseiRequest(
                    technique: widget.technique,
                    reviewedRequest: analysis.reviewedRequest,
                    reviewedResult: analysis.result,
                    locale: Localizations.localeOf(context).languageCode,
                  ),
                );
        if (mounted && revision == _contextRevision) {
          setState(() {
            _explanation = explanation;
            _senseiUnavailable = false;
          });
        }
      } catch (_) {
        if (mounted && revision == _contextRevision) {
          setState(() {
            _explanation = null;
            _senseiUnavailable = true;
          });
        }
      }
    } on GuidedReviewException catch (error) {
      if (mounted) {
        setState(() {
          _error = error.message;
          _session = null;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _error = l10n.guidedReviewBackendError);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Material(
      key: const ValueKey('guided-single-attempt-review'),
      color: JudoColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(JudoRadius.lg),
        side: BorderSide(color: JudoColors.primary.withValues(alpha: .55)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(JudoSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.guidedReviewTitle, style: JudoTypography.titleLarge),
            const SizedBox(height: JudoSpacing.xs),
            Text(
              l10n.guidedReviewDescription,
              style: JudoTypography.bodySmall.copyWith(
                color: JudoColors.textSecondary,
              ),
            ),
            const SizedBox(height: JudoSpacing.lg),
            if (_session == null) ...[
              DropdownButtonFormField<SourceTimingState>(
                key: const ValueKey('guided-source-timing'),
                initialValue: _sourceTiming,
                decoration: InputDecoration(labelText: l10n.guidedSourceTiming),
                items: [
                  DropdownMenuItem(
                    value: SourceTimingState.realTime,
                    child: Text(l10n.guidedSourceRealTime),
                  ),
                  DropdownMenuItem(
                    value: SourceTimingState.unknown,
                    child: Text(l10n.guidedSourceTimingUnknown),
                  ),
                ],
                onChanged: !_busy && _manifest == null
                    ? (value) => setState(() {
                        _contextRevision += 1;
                        _invalidatePreparedAttempt();
                        _sourceTiming = value;
                      })
                    : null,
              ),
              if (_manifest == null)
                ElevatedButton(
                  key: const ValueKey('load-timing-manifest'),
                  onPressed: _busy ? null : _loadTimingManifest,
                  child: Text(l10n.guidedLoadFrames),
                )
              else ...[
                Text(
                  l10n.guidedTimingEvidence(
                    _manifest!.timingMode,
                    _manifest!.timestampProvenance,
                  ),
                  key: const ValueKey('guided-timing-evidence'),
                ),
                _frameSelector(
                  label: l10n.guidedAttemptStartFrame,
                  value: _startFrame,
                  minimum: 0,
                  maximum: _endFrame - 1,
                  key: const ValueKey('guided-attempt-start'),
                  onChanged: _busy
                      ? null
                      : (value) {
                          setState(() {
                            _startFrame = value;
                            if (_momentFrame < value) _momentFrame = value;
                            _contextRevision += 1;
                            _invalidatePreparedAttempt();
                          });
                          _seekFrame(value);
                        },
                ),
                _frameSelector(
                  label: l10n.guidedAttemptEndFrame,
                  value: _endFrame,
                  minimum: _startFrame + 1,
                  maximum: _manifest!.totalDecodedFrames - 1,
                  key: const ValueKey('guided-attempt-end'),
                  onChanged: _busy
                      ? null
                      : (value) {
                          setState(() {
                            _endFrame = value;
                            if (_momentFrame > value) _momentFrame = value;
                            _contextRevision += 1;
                            _invalidatePreparedAttempt();
                          });
                          _seekFrame(value);
                        },
                ),
                _frameSelector(
                  label: l10n.guidedReviewMoment,
                  value: _momentFrame,
                  minimum: _startFrame,
                  maximum: _endFrame,
                  key: const ValueKey('guided-review-moment'),
                  onChanged: _busy
                      ? null
                      : (value) {
                          setState(() {
                            _momentFrame = value;
                            _contextRevision += 1;
                            _invalidatePreparedAttempt();
                          });
                          _seekFrame(value);
                        },
                ),
                Text(l10n.guidedBoundaryVisualReview),
                OutlinedButton(
                  key: const ValueKey('review-exact-boundaries'),
                  onPressed: _busy ? null : _reviewBoundaries,
                  child: Text(l10n.guidedPrepareReview),
                ),
                if (_boundaryPreview != null) ...[
                  Text(l10n.guidedAttemptStartFrame),
                  Image.memory(
                    base64Decode(_boundaryPreview!.startPreviewJpegBase64),
                    key: const ValueKey('guided-start-boundary-preview'),
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                  Text(l10n.guidedAttemptEndFrame),
                  Image.memory(
                    base64Decode(_boundaryPreview!.endPreviewJpegBase64),
                    key: const ValueKey('guided-end-boundary-preview'),
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                ],
                CheckboxListTile(
                  key: const ValueKey('confirm-attempt-boundaries'),
                  value: _boundariesConfirmed,
                  onChanged: _busy || _boundaryPreview == null
                      ? null
                      : (value) => setState(() {
                          _boundariesConfirmed = value ?? false;
                          if (!_boundariesConfirmed) {
                            _singleAttemptConfirmed = false;
                          }
                        }),
                  title: Text(l10n.guidedConfirmAttemptBoundaries),
                ),
                Text(l10n.guidedSingleAttemptCaptureGuidance),
                CheckboxListTile(
                  key: const ValueKey('confirm-single-attempt-scope'),
                  value: _singleAttemptConfirmed,
                  onChanged: _busy || !_boundariesConfirmed
                      ? null
                      : (value) => setState(
                          () => _singleAttemptConfirmed = value ?? false,
                        ),
                  title: Text(
                    l10n.guidedConfirmSingleAttempt(_localizedTechniqueName()),
                  ),
                ),
              ],
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  key: const ValueKey('prepare-guided-review'),
                  onPressed:
                      _busy || !_boundariesConfirmed || !_singleAttemptConfirmed
                      ? null
                      : _prepare,
                  child: Text(
                    _busy ? l10n.guidedPreparing : l10n.guidedPrepareReview,
                  ),
                ),
              ),
            ] else ...[
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: OutlinedButton.icon(
                  key: const ValueKey('edit-attempt-boundaries'),
                  onPressed: _busy ? null : _editAttemptBoundaries,
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(l10n.guidedEditAttemptBoundaries),
                ),
              ),
              Text(l10n.guidedSelectTori, style: JudoTypography.titleMedium),
              Text(
                l10n.guidedToriBoundary,
                style: JudoTypography.bodySmall.copyWith(
                  color: JudoColors.warning,
                ),
              ),
              Text(
                l10n.guidedFrameCandidateEvidenceBoundary,
                key: const ValueKey('guided-candidate-evidence-boundary'),
                style: JudoTypography.bodySmall.copyWith(
                  color: JudoColors.textSecondary,
                ),
              ),
              const SizedBox(height: JudoSpacing.md),
              ..._session!.candidates.asMap().entries.map((entry) {
                final selected = _candidateToken == entry.value.token;
                return InkWell(
                  key: ValueKey('guided-candidate-${entry.key}'),
                  onTap: _busy || !_session!.hasReadyCandidateEvidence
                      ? null
                      : () => _humanReviewChanged(() {
                          _resetHumanReview();
                          _candidateToken = entry.value.token;
                        }),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: JudoSpacing.sm,
                    ),
                    child: Column(
                      children: [
                        Image.memory(
                          base64Decode(entry.value.previewJpegBase64),
                          height: 180,
                          fit: BoxFit.contain,
                        ),
                        Row(
                          children: [
                            Icon(
                              selected
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: selected
                                  ? JudoColors.primary
                                  : JudoColors.textSecondary,
                            ),
                            const SizedBox(width: JudoSpacing.sm),
                            Text(l10n.guidedCandidate(entry.key + 1)),
                          ],
                        ),
                        Text(
                          l10n.guidedCandidatePoseEvidence(
                            entry.value.availableRequiredLandmarkCount,
                            entry.value.requiredLandmarkCount,
                          ),
                          style: JudoTypography.bodySmall.copyWith(
                            color: JudoColors.textSecondary,
                          ),
                        ),
                        Text(
                          _candidateVisibilityText(l10n, entry.value),
                          style: JudoTypography.bodySmall.copyWith(
                            color: JudoColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              _candidateEvidenceStatus(l10n, _session!),
              const SizedBox(height: JudoSpacing.sm),
              CheckboxListTile(
                key: const ValueKey('guided-confirm-tori'),
                value: _toriConfirmed,
                onChanged: _busy || _candidateToken == null
                    ? null
                    : (value) => _humanReviewChanged(
                        () => _toriConfirmed = value ?? false,
                      ),
                title: Text(l10n.guidedConfirmTori),
              ),
              _legField<ReviewedSupportLeg>(
                key: const ValueKey('guided-support-leg'),
                label: l10n.reviewedSupportLeg,
                value: _supportLeg,
                values: ReviewedSupportLeg.values,
                onChanged: _busy
                    ? null
                    : (value) => _humanReviewChanged(() => _supportLeg = value),
              ),
              _legField<ReviewedAttackingLeg>(
                key: const ValueKey('guided-attacking-leg'),
                label: l10n.reviewedAttackingLeg,
                value: _attackingLeg,
                values: ReviewedAttackingLeg.values,
                onChanged: _busy
                    ? null
                    : (value) =>
                          _humanReviewChanged(() => _attackingLeg = value),
              ),
              _answerField(
                const ValueKey('guided-view-suitable'),
                l10n.reviewedProjectedViewSuitable,
                _viewSuitable,
                _busy
                    ? null
                    : (value) =>
                          _humanReviewChanged(() => _viewSuitable = value),
              ),
              _answerField(
                const ValueKey('guided-low-roll'),
                l10n.reviewedLowRoll,
                _lowRoll,
                _busy
                    ? null
                    : (value) => _humanReviewChanged(() => _lowRoll = value),
              ),
              CheckboxListTile(
                key: const ValueKey('guided-review-uncertain'),
                value: _reviewerUncertain,
                onChanged: _busy
                    ? null
                    : (value) => _humanReviewChanged(
                        () => _reviewerUncertain = value ?? false,
                      ),
                title: Text(l10n.guidedNotSureAthlete),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  key: const ValueKey('run-guided-v2a'),
                  onPressed: _busy || !_canAnalyze ? null : _analyze,
                  child: Text(
                    _busy
                        ? l10n.reviewedAnalysisRunning
                        : l10n.runReviewedAnalysis,
                  ),
                ),
              ),
            ],
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: JudoSpacing.md),
                child: Text(
                  _error!,
                  key: const ValueKey('guided-review-error'),
                  style: JudoTypography.bodySmall.copyWith(
                    color: JudoColors.danger,
                  ),
                ),
              ),
            if (_result != null) ...[
              const SizedBox(height: JudoSpacing.lg),
              SingleAttemptV2AResultCard(result: _result!),
              if (_explanation != null)
                GroundedSenseiExplanationCard(explanation: _explanation!),
              if (_senseiUnavailable)
                Text(
                  l10n.groundedSenseiUnavailable,
                  key: const ValueKey('grounded-sensei-unavailable'),
                ),
              _saveAction(_result!, l10n),
            ],
          ],
        ),
      ),
    );
  }

  Widget _frameSelector({
    required String label,
    required int value,
    required int minimum,
    required int maximum,
    required ValueChanged<int>? onChanged,
    required Key key,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final safeMaximum = maximum < minimum ? minimum : maximum;
    final safeValue = value.clamp(minimum, safeMaximum);
    final timestamp = _manifest?.timestampForFrame(safeValue) ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: $safeValue · ${_time(timestamp.toDouble())}'),
        Slider(
          key: key,
          value: safeValue.toDouble(),
          min: minimum.toDouble(),
          max: safeMaximum.toDouble(),
          divisions: safeMaximum > minimum ? safeMaximum - minimum : null,
          onChanged: onChanged == null
              ? null
              : (next) => onChanged(next.round()),
        ),
        Row(
          children: [
            IconButton(
              key: ValueKey('${key.toString()}-previous-frame'),
              tooltip: l10n.guidedPreviousFrame,
              onPressed: onChanged != null && safeValue > minimum
                  ? () => onChanged(safeValue - 1)
                  : null,
              icon: const Icon(Icons.skip_previous),
            ),
            IconButton(
              key: ValueKey('${key.toString()}-next-frame'),
              tooltip: l10n.guidedNextFrame,
              onPressed: onChanged != null && safeValue < safeMaximum
                  ? () => onChanged(safeValue + 1)
                  : null,
              icon: const Icon(Icons.skip_next),
            ),
          ],
        ),
      ],
    );
  }

  Widget _legField<T extends Enum>({
    required Key key,
    required String label,
    required T? value,
    required List<T> values,
    required ValueChanged<T?>? onChanged,
  }) => DropdownButtonFormField<T>(
    key: key,
    initialValue: value,
    decoration: InputDecoration(labelText: label),
    items: values
        .map((item) => DropdownMenuItem(value: item, child: Text(item.name)))
        .toList(),
    onChanged: onChanged,
  );

  Widget _answerField(
    Key key,
    String label,
    _ReviewAnswer? value,
    ValueChanged<_ReviewAnswer?>? changed,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return DropdownButtonFormField<_ReviewAnswer>(
      key: key,
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      items: [
        DropdownMenuItem(
          value: _ReviewAnswer.yes,
          child: Text(l10n.reviewedYes),
        ),
        DropdownMenuItem(value: _ReviewAnswer.no, child: Text(l10n.reviewedNo)),
        DropdownMenuItem(
          value: _ReviewAnswer.notSure,
          child: Text(l10n.guidedNotSure),
        ),
      ],
      onChanged: changed,
    );
  }

  Widget _saveAction(SingleAttemptAnalysisV2A result, AppLocalizations l10n) =>
      Consumer<LocalAttemptHistoryProvider>(
        builder: (context, history, child) => Padding(
          padding: const EdgeInsets.only(top: JudoSpacing.md),
          child: OutlinedButton(
            key: const ValueKey('save-v2a-attempt-locally'),
            onPressed: history.isSaving ? null : () => history.save(result),
            child: Text(l10n.saveAttemptLocally),
          ),
        ),
      );
}
