import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/ai/analysis/single_camera_analysis_service.dart';
import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/single_camera_pose_summary.dart';
import '../../../../models/technique_model.dart';
import '../../../../models/video_analysis_request.dart';
import 'single_camera_pose_summary_card.dart';

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

  const AnalyzeSection({
    super.key,
    required this.technique,
    this.analysisService,
  });

  @override
  State<AnalyzeSection> createState() => _AnalyzeSectionState();
}

class _AnalyzeSectionState extends State<AnalyzeSection> {
  final ImagePicker _picker = ImagePicker();

  XFile? _selectedVideo;
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
          SnackBar(content: Text('Video could not be selected: $error')),
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

    final controller = VideoPlayerController.file(File(video.path));

    await controller.initialize();
    await controller.setLooping(true);

    if (!mounted) {
      await controller.dispose();
      return;
    }

    setState(() {
      _selectedVideo = video;
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

    return '${megabytes.toStringAsFixed(1)} MB';
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
        _analysisError = error.message;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _analysisError = 'Pose analysis failed unexpectedly.';
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
          'Analyze My ${widget.technique.nameEn}',
          style: JudoTypography.headingSmall.copyWith(color: JudoColors.gold),
        ),
        const SizedBox(height: JudoSpacing.sm),
        Text(
          'Upload a training or competition video for an experimental 2D pose visibility check. Identity, phases and biomechanics are not included in this slice.',
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
        ],
      ],
    );
  }

  Widget _buildVideoSelection() {
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
            'Add Technique Video',
            style: JudoTypography.titleLarge.copyWith(
              color: JudoColors.textPrimary,
            ),
          ),
          const SizedBox(height: JudoSpacing.sm),
          Text(
            'Use a clear video where both judoka remain visible.',
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
              label: const Text('Choose from Gallery'),
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
              label: const Text('Record Video'),
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
                        _selectedVideo?.name ?? 'Selected video',
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
    return Container(
      padding: const EdgeInsets.all(JudoSpacing.lg),
      decoration: BoxDecoration(
        color: JudoColors.surface,
        borderRadius: BorderRadius.circular(JudoRadius.md),
        border: Border.all(color: JudoColors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _GuidanceItem(text: 'Keep the full bodies of Tori and Uke visible.'),
          _GuidanceItem(text: 'Use stable recording with sufficient light.'),
          _GuidanceItem(text: 'Avoid people crossing in front of the camera.'),
          _GuidanceItem(
            text: 'Side or 45-degree views provide better joint visibility.',
          ),
          _GuidanceItem(
            text: 'Maximum video duration in this phase is 3 minutes.',
          ),
        ],
      ),
    );
  }

  Widget _buildCameraAngleSelector() {
    const angles = {
      AnalysisCameraView.side: 'Side view',
      AnalysisCameraView.front: 'Front view',
      AnalysisCameraView.rear: 'Rear view',
      AnalysisCameraView.fortyFiveDegrees: '45-degree view',
      AnalysisCameraView.unknown: 'Unknown',
    };

    return DropdownButtonFormField<AnalysisCameraView>(
      initialValue: _cameraView,
      dropdownColor: JudoColors.surfaceVariant,
      decoration: InputDecoration(
        labelText: 'Camera angle',
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
          'I understand this is video-based analysis.',
          style: JudoTypography.titleSmall.copyWith(color: JudoColors.warning),
        ),
        subtitle: Text(
          'This step reports experimental 2D pose visibility only. It does not identify Tori/Uke, detect phases, reconstruct 3D, or measure force and torque.',
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
