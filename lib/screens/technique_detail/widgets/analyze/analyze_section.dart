import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/ai/analysis/single_camera_analysis_service.dart';
import '../../../../core/ai/analysis/grounded_sensei_service.dart';
import '../../../../core/ai/analysis/guided_single_attempt_v2a_service.dart';
import '../../../../core/ai/analysis/single_attempt_v2a_service.dart';
import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/single_camera_pose_summary.dart';
import '../../../../models/technique_model.dart';
import '../../../../models/video_analysis_request.dart';
import 'single_camera_pose_summary_card.dart';
import 'guided_single_attempt_review_panel.dart';

/// ----------------------------------------------------------------
/// Judo Mind Super App
/// Section: AI Video Analysis Entry
/// Module: Fight Intelligence 360
/// Version: 1.0.0
/// ----------------------------------------------------------------
///
/// Current responsibility:
/// - Select or record a technique video.
/// - Preview the selected video.
/// - Collect camera-angle metadata.
/// - Explain scientific limitations.
/// - Submit to the bounded single-camera pose-summary endpoint.
/// - Display measured metadata, model-estimated coverage, and limitations.
///
/// This widget does not generate fake biomechanical results.
class AnalyzeSection extends StatefulWidget {
  final TechniqueModel technique;
  final SingleCameraAnalysisService? analysisService;
  final SingleAttemptV2AService? singleAttemptV2AService;
  final GuidedSingleAttemptV2AService? guidedSingleAttemptV2AService;
  final GroundedSenseiService? groundedSenseiService;

  const AnalyzeSection({
    super.key,
    required this.technique,
    this.analysisService,
    this.singleAttemptV2AService,
    this.guidedSingleAttemptV2AService,
    this.groundedSenseiService,
  });

  @override
  State<AnalyzeSection> createState() => _AnalyzeSectionState();
}

class _AnalyzeSectionState extends State<AnalyzeSection> {
  final ImagePicker _picker = ImagePicker();

  XFile? _selectedVideo;
  String? _selectedVideoId;
  VideoPlayerController? _videoController;

  bool _isSelectingVideo = false;
  bool _isAnalyzing = false;
  bool _acceptedAnalysisNotice = false;

  AnalysisCameraView _cameraView = AnalysisCameraView.side;
  SingleCameraPoseSummary? _analysisResult;
  String? _analysisError;

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _pickVideo(ImageSource source) async {
    if (_isSelectingVideo) {
      return;
    }

    setState(() {
      _isSelectingVideo = true;
    });

    try {
      final video = await _picker.pickVideo(
        source: source,
        maxDuration: const Duration(minutes: 3),
      );

      if (video == null || !mounted) {
        return;
      }

      await _loadVideo(video);
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.videoSelectionFailed),
          ),
        );
    } finally {
      if (mounted) {
        setState(() {
          _isSelectingVideo = false;
        });
      }
    }
  }

  Future<void> _loadVideo(XFile video) async {
    final previousController = _videoController;
    final videoLength = await video.length();
    final videoId =
        'local-${video.name}-$videoLength-${DateTime.now().microsecondsSinceEpoch}';

    final controller = VideoPlayerController.file(File(video.path));

    await controller.initialize();
    await controller.setLooping(true);

    if (!mounted) {
      await controller.dispose();
      return;
    }

    setState(() {
      _selectedVideo = video;
      _selectedVideoId = videoId;
      _videoController = controller;
      _analysisResult = null;
      _analysisError = null;
    });

    await previousController?.dispose();
  }

  Future<void> _removeVideo() async {
    final controller = _videoController;

    setState(() {
      _selectedVideo = null;
      _selectedVideoId = null;
      _videoController = null;
      _acceptedAnalysisNotice = false;
      _analysisResult = null;
      _analysisError = null;
    });

    await controller?.dispose();
  }

  void _togglePlayback() {
    final controller = _videoController;

    if (controller == null) {
      return;
    }

    setState(() {
      if (controller.value.isPlaying) {
        controller.pause();
      } else {
        controller.play();
      }
    });
  }

  Future<String> _videoSizeLabel() async {
    final video = _selectedVideo;

    if (video == null) {
      return '';
    }

    final bytes = await video.length();
    final megabytes = bytes / (1024 * 1024);
    if (!mounted) {
      return '';
    }

    return AppLocalizations.of(
      context,
    )!.videoSizeMegabytes(megabytes.toStringAsFixed(1));
  }

  Future<void> _submitForAnalysis() async {
    final video = _selectedVideo;
    if (video == null || _isAnalyzing || !_acceptedAnalysisNotice) {
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _analysisError = null;
      _analysisResult = null;
    });

    try {
      final service =
          widget.analysisService ?? sl<SingleCameraAnalysisService>();
      final result = await service.analyzePoseSummary(
        VideoAnalysisRequest.singleCameraPoseSummary(
          techniqueId: widget.technique.id,
          techniqueName: widget.technique.nameEn,
          videoPath: video.path,
          cameraView: _cameraView,
          createdAt: DateTime.now(),
        ),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _analysisResult = result;
      });
    } on SingleCameraAnalysisException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _analysisError = Localizations.localeOf(context).languageCode == 'en'
            ? error.message
            : AppLocalizations.of(context)!.analysisFailedUnexpectedly;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _analysisError = AppLocalizations.of(
          context,
        )!.analysisFailedUnexpectedly;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final videoController = _videoController;

    final hasReadyVideo =
        _selectedVideo != null &&
        videoController != null &&
        videoController.value.isInitialized;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.analyzeTechnique(
            widget.technique
                .resolveContent(Localizations.localeOf(context).languageCode)
                .name,
          ),
          style: JudoTypography.headingSmall.copyWith(color: JudoColors.gold),
        ),
        const SizedBox(height: JudoSpacing.sm),
        Text(
          l10n.analyzeVideoDescription,
          style: JudoTypography.bodyMedium.copyWith(
            color: JudoColors.textSecondary,
          ),
        ),
        const SizedBox(height: JudoSpacing.xl),

        if (hasReadyVideo)
          _buildVideoPreview(videoController)
        else
          _buildVideoSelection(),

        const SizedBox(height: JudoSpacing.xl),

        _buildCaptureGuidance(),

        if (hasReadyVideo) ...[
          const SizedBox(height: JudoSpacing.xl),
          _buildCameraAngleSelector(),
          const SizedBox(height: JudoSpacing.lg),
          _buildAnalysisNotice(),
          const SizedBox(height: JudoSpacing.lg),
          SizedBox(
            width: double.infinity,
            height: JudoButtonHeight.large,
            child: ElevatedButton.icon(
              onPressed: _acceptedAnalysisNotice && !_isAnalyzing
                  ? _submitForAnalysis
                  : null,
              icon: _isAnalyzing
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.accessibility_new_rounded),
              label: Text(
                _isAnalyzing ? l10n.poseAnalysisRunning : l10n.runPoseAnalysis,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: JudoColors.primary,
                foregroundColor: JudoColors.white,
                disabledBackgroundColor: JudoColors.surfaceVariant,
                disabledForegroundColor: JudoColors.textHint,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(JudoRadius.md),
                ),
              ),
            ),
          ),
          if (_analysisError != null) ...[
            const SizedBox(height: JudoSpacing.md),
            Text(
              _analysisError!,
              style: JudoTypography.bodySmall.copyWith(
                color: JudoColors.danger,
              ),
            ),
          ],
          if (_analysisResult != null) ...[
            const SizedBox(height: JudoSpacing.xl),
            SingleCameraPoseSummaryCard(summary: _analysisResult!),
          ],
          if (_supportsReviewedV2A && _selectedVideoId != null) ...[
            const SizedBox(height: JudoSpacing.xl),
            GuidedSingleAttemptReviewPanel(
              key: ValueKey(
                'guided-v2a-${_selectedVideoId!}-${_cameraView.apiValue}',
              ),
              videoPath: _selectedVideo!.path,
              videoId: _selectedVideoId!,
              cameraView: _cameraView.apiValue,
              videoDuration: videoController.value.duration,
              onPreviewMoment: (moment) {
                videoController.pause();
                videoController.seekTo(moment);
              },
              technique: widget.technique,
              service:
                  widget.guidedSingleAttemptV2AService ??
                  sl<GuidedSingleAttemptV2AService>(),
              groundedSenseiService: widget.groundedSenseiService,
            ),
          ],
        ],
      ],
    );
  }

  bool get _supportsReviewedV2A =>
      widget.technique.supportsReviewedSingleAttemptV2A;

  Widget _buildVideoSelection() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(JudoSpacing.xl),
      decoration: BoxDecoration(
        color: JudoColors.surface,
        borderRadius: BorderRadius.circular(JudoRadius.lg),
        border: Border.all(color: JudoColors.gold.withValues(alpha: 0.35)),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: JudoColors.gold.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.video_call_outlined,
              color: JudoColors.gold,
              size: JudoIconSize.xl,
            ),
          ),
          const SizedBox(height: JudoSpacing.lg),
          Text(
            l10n.addTechniqueVideo,
            style: JudoTypography.titleLarge.copyWith(
              color: JudoColors.textPrimary,
            ),
          ),
          const SizedBox(height: JudoSpacing.sm),
          Text(
            l10n.videoVisibilityGuidance,
            textAlign: TextAlign.center,
            style: JudoTypography.bodySmall.copyWith(
              color: JudoColors.textSecondary,
            ),
          ),
          const SizedBox(height: JudoSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isSelectingVideo
                  ? null
                  : () {
                      _pickVideo(ImageSource.gallery);
                    },
              icon: const Icon(Icons.video_library_outlined),
              label: Text(l10n.chooseFromGallery),
            ),
          ),
          const SizedBox(height: JudoSpacing.sm),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _isSelectingVideo
                  ? null
                  : () {
                      _pickVideo(ImageSource.camera);
                    },
              icon: const Icon(Icons.videocam_outlined),
              label: Text(l10n.recordVideo),
            ),
          ),
          if (_isSelectingVideo) ...[
            const SizedBox(height: JudoSpacing.lg),
            const CircularProgressIndicator(color: JudoColors.gold),
          ],
        ],
      ),
    );
  }

  Widget _buildVideoPreview(VideoPlayerController controller) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: JudoColors.surface,
        borderRadius: BorderRadius.circular(JudoRadius.lg),
        border: Border.all(color: JudoColors.primary.withValues(alpha: 0.45)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: Stack(
              fit: StackFit.expand,
              children: [
                VideoPlayer(controller),
                Center(
                  child: IconButton.filled(
                    onPressed: _togglePlayback,
                    style: IconButton.styleFrom(
                      backgroundColor: JudoColors.background.withValues(
                        alpha: 0.72,
                      ),
                    ),
                    iconSize: JudoIconSize.xl,
                    icon: Icon(
                      controller.value.isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(JudoSpacing.md),
            child: Row(
              children: [
                const Icon(
                  Icons.video_file_outlined,
                  color: JudoColors.primary,
                  size: JudoIconSize.md,
                ),
                const SizedBox(width: JudoSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedVideo?.name ?? l10n.selectedVideo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: JudoTypography.titleSmall,
                      ),
                      FutureBuilder<String>(
                        future: _videoSizeLabel(),
                        builder: (context, snapshot) {
                          return Text(
                            snapshot.data ?? '',
                            style: JudoTypography.bodySmall.copyWith(
                              color: JudoColors.textSecondary,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _removeVideo,
                  color: JudoColors.danger,
                  icon: const Icon(Icons.delete_outline_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptureGuidance() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(JudoSpacing.lg),
      decoration: BoxDecoration(
        color: JudoColors.surface,
        borderRadius: BorderRadius.circular(JudoRadius.md),
        border: Border.all(color: JudoColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _GuidanceItem(text: l10n.captureFullBodiesGuidance),
          _GuidanceItem(text: l10n.captureStableLightGuidance),
          _GuidanceItem(text: l10n.captureNoCrossingGuidance),
          _GuidanceItem(text: l10n.captureViewGuidance),
          _GuidanceItem(text: l10n.captureDurationGuidance),
        ],
      ),
    );
  }

  Widget _buildCameraAngleSelector() {
    final l10n = AppLocalizations.of(context)!;
    final angles = {
      AnalysisCameraView.side: l10n.cameraSideView,
      AnalysisCameraView.front: l10n.cameraFrontView,
      AnalysisCameraView.rear: l10n.cameraRearView,
      AnalysisCameraView.fortyFiveDegrees: l10n.cameraFortyFiveView,
      AnalysisCameraView.unknown: l10n.unknownLabel,
    };

    return DropdownButtonFormField<AnalysisCameraView>(
      initialValue: _cameraView,
      dropdownColor: JudoColors.surfaceVariant,
      decoration: InputDecoration(
        labelText: l10n.cameraAngleLabel,
        prefixIcon: const Icon(Icons.camera_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(JudoRadius.md),
        ),
      ),
      items: angles.entries
          .map(
            (entry) =>
                DropdownMenuItem(value: entry.key, child: Text(entry.value)),
          )
          .toList(),
      onChanged: (value) {
        if (value == null) {
          return;
        }

        setState(() {
          _cameraView = value;
          _analysisResult = null;
          _analysisError = null;
        });
      },
    );
  }

  Widget _buildAnalysisNotice() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(JudoSpacing.md),
      decoration: BoxDecoration(
        color: JudoColors.warning.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(JudoRadius.md),
        border: Border.all(color: JudoColors.warning.withValues(alpha: 0.35)),
      ),
      child: CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        activeColor: JudoColors.warning,
        value: _acceptedAnalysisNotice,
        onChanged: (value) {
          setState(() {
            _acceptedAnalysisNotice = value ?? false;
          });
        },
        title: Text(
          l10n.analysisNoticeTitle,
          style: JudoTypography.titleSmall.copyWith(color: JudoColors.warning),
        ),
        subtitle: Text(
          l10n.analysisNoticeDescription,
          style: JudoTypography.bodySmall.copyWith(
            color: JudoColors.textSecondary,
          ),
        ),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}

class _GuidanceItem extends StatelessWidget {
  final String text;

  const _GuidanceItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: JudoSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: JudoColors.success,
            size: JudoIconSize.sm,
          ),
          const SizedBox(width: JudoSpacing.sm),
          Expanded(child: Text(text, style: JudoTypography.bodySmall)),
        ],
      ),
    );
  }
}
