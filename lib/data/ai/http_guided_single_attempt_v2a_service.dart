import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/ai/analysis/guided_single_attempt_v2a_service.dart';
import '../../core/ai/config/ai_api_config.dart';
import '../../models/guided_single_attempt_review.dart';
import '../../models/single_attempt_analysis_v2a.dart';
import '../../models/single_attempt_v2a_request.dart';

class HttpGuidedSingleAttemptV2AService
    implements GuidedSingleAttemptV2AService {
  HttpGuidedSingleAttemptV2AService({
    required this.client,
    this.timeout = const Duration(minutes: 2),
  });
  final http.Client client;
  final Duration timeout;

  @override
  Future<GuidedTimingManifest> prepareTimingManifest(
    GuidedTimingManifestRequest request,
  ) async {
    try {
      final upload =
          http.MultipartRequest('POST', AiApiConfig.guidedTimingManifestUri())
            ..fields['timing_json'] = jsonEncode(request.toJson())
            ..files.add(
              await http.MultipartFile.fromPath('video', request.videoPath),
            );
      final streamed = await client.send(upload).timeout(timeout);
      final response = await http.Response.fromStream(streamed);
      final body = _responseMap(response);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw GuidedReviewException(_detail(body, response.statusCode));
      }
      return GuidedTimingManifest.fromJson(body);
    } on GuidedReviewException {
      rethrow;
    } on TimeoutException {
      throw const GuidedReviewException(
        'Preparing decoded frame timing timed out.',
      );
    } catch (_) {
      throw const GuidedReviewException(
        'The timing manifest could not be prepared.',
      );
    }
  }

  @override
  Future<GuidedReviewSession> prepare(
    GuidedReviewPrepareRequest request,
  ) async {
    if (request.techniqueId != 'uchi-mata' ||
        !request.boundariesConfirmed ||
        request.attemptEndFrame <= request.attemptStartFrame ||
        request.reviewFrame < request.attemptStartFrame ||
        request.reviewFrame > request.attemptEndFrame) {
      throw const GuidedReviewException(
        'The guided review selection is incomplete.',
      );
    }
    try {
      final upload =
          http.MultipartRequest('POST', AiApiConfig.guidedReviewPrepareUri())
            ..fields['selection_json'] = jsonEncode(request.toJson())
            ..files.add(
              await http.MultipartFile.fromPath('video', request.videoPath),
            );
      final streamed = await client.send(upload).timeout(timeout);
      final response = await http.Response.fromStream(streamed);
      final body = _responseMap(response);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw GuidedReviewException(_detail(body, response.statusCode));
      }
      return GuidedReviewSession.fromJson(body);
    } on GuidedReviewException {
      rethrow;
    } on TimeoutException {
      throw const GuidedReviewException(
        'Preparing the selected review moment timed out.',
      );
    } on FileSystemException {
      throw const GuidedReviewException(
        'The selected video file could not be opened.',
      );
    } catch (_) {
      throw const GuidedReviewException(
        'The guided review service could not be reached.',
      );
    }
  }

  @override
  Future<GuidedBoundaryPreview> previewBoundaries(
    GuidedReviewPrepareRequest request,
  ) async {
    try {
      final selection = Map<String, dynamic>.from(request.toJson())
        ..remove('technique_id')
        ..remove('camera_view')
        ..remove('boundaries_confirmed');
      final upload =
          http.MultipartRequest('POST', AiApiConfig.guidedBoundaryPreviewUri())
            ..fields['selection_json'] = jsonEncode(selection)
            ..files.add(
              await http.MultipartFile.fromPath('video', request.videoPath),
            );
      final streamed = await client.send(upload).timeout(timeout);
      final response = await http.Response.fromStream(streamed);
      final body = _responseMap(response);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw GuidedReviewException(_detail(body, response.statusCode));
      }
      return GuidedBoundaryPreview.fromJson(body);
    } on GuidedReviewException {
      rethrow;
    } on TimeoutException {
      throw const GuidedReviewException('Boundary preview timed out.');
    } catch (_) {
      throw const GuidedReviewException(
        'Exact boundary preview failed safely.',
      );
    }
  }

  @override
  Future<GuidedReviewAnalysis> analyze(
    GuidedReviewPrepareRequest preparedRequest,
    GuidedReviewConfirmation confirmation,
  ) async {
    try {
      final response = await client
          .post(
            AiApiConfig.guidedReviewAnalyzeUri(),
            headers: const {'content-type': 'application/json'},
            body: jsonEncode(confirmation.toJson()),
          )
          .timeout(timeout);
      final body = _responseMap(response);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw GuidedReviewException(_detail(body, response.statusCode));
      }
      final result = SingleAttemptAnalysisV2A.fromJson(body);
      if (!result.hasExpectedScientificBoundary ||
          result.videoId != preparedRequest.videoId ||
          result.techniqueId != 'uchi-mata') {
        throw const GuidedReviewException(
          'The guided result does not satisfy the scientific safety boundary.',
        );
      }
      final reviewedRequest = SingleAttemptV2ARequest(
        videoPath: preparedRequest.videoPath,
        videoId: result.videoId,
        cameraView: result.cameraView,
        attemptStart: ReviewedFrameReference(
          frameIndex: result.attempt.start.frameIndex,
          timestampMs: result.attempt.start.timestampMs,
        ),
        attemptEnd: ReviewedFrameReference(
          frameIndex: result.attempt.end.frameIndex,
          timestampMs: result.attempt.end.timestampMs,
        ),
        eventSchemaId: result.attempt.eventSchemaId,
        neutralTrackId: result.subject.neutralTrackId,
        selectedDetectionIndex: result.subject.selectedDetectionIndex,
        supportLeg: confirmation.supportLeg,
        attackingLeg: confirmation.attackingLeg,
        angleFrame: ReviewedFrameReference(
          frameIndex: result.angleFrame.frame.frameIndex,
          timestampMs: result.angleFrame.frame.timestampMs,
        ),
        angleEventLabel: result.angleFrame.eventLabel,
        projectedAngleViewSuitable: confirmation.projectedAngleViewSuitable,
        lowRollConfirmed: confirmation.lowRollConfirmed,
        singleAttemptConfirmed: result.attempt.singleAttemptConfirmed,
        attemptScope: result.attempt.attemptScope,
        attemptScopeSource: result.attempt.attemptScopeSource,
        attemptScopeContractVersion: result.attempt.attemptScopeContractVersion,
      );
      if (!result.matchesReviewedRequest(reviewedRequest)) {
        throw const GuidedReviewException(
          'The guided result does not match the confirmed review.',
        );
      }
      return GuidedReviewAnalysis(
        result: result,
        reviewedRequest: reviewedRequest,
      );
    } on GuidedReviewException {
      rethrow;
    } on TimeoutException {
      throw const GuidedReviewException('The confirmed analysis timed out.');
    } on FormatException {
      throw const GuidedReviewException(
        'The AI Engine returned an incompatible response.',
      );
    } catch (_) {
      throw const GuidedReviewException(
        'The confirmed review could not be analyzed.',
      );
    }
  }

  Map<String, dynamic> _responseMap(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) return decoded;
    } on FormatException {
      // Converted to a bounded error below.
    }
    throw const GuidedReviewException(
      'The AI Engine returned an invalid response.',
    );
  }

  String _detail(Map<String, dynamic> body, int statusCode) {
    final detail = body['detail'];
    return detail is String && detail.isNotEmpty
        ? detail
        : 'The guided review was rejected (HTTP $statusCode).';
  }
}
