import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/ai/analysis/single_camera_analysis_service.dart';
import '../../core/ai/config/ai_api_config.dart';
import '../../models/single_camera_pose_summary.dart';
import '../../models/video_analysis_request.dart';

class HttpSingleCameraAnalysisService implements SingleCameraAnalysisService {
  HttpSingleCameraAnalysisService({
    required this.client,
    Uri? endpoint,
    this.timeout = const Duration(minutes: 5),
  }) : _endpoint = endpoint ?? AiApiConfig.singleCameraPoseSummaryUri();

  final http.Client client;
  final Uri _endpoint;
  final Duration timeout;

  @override
  Future<SingleCameraPoseSummary> analyzePoseSummary(
    VideoAnalysisRequest request,
  ) async {
    if (!request.isValid) {
      throw const SingleCameraAnalysisException(
        'The video analysis request is incomplete.',
      );
    }

    final upload = http.MultipartRequest('POST', _endpoint)
      ..fields.addAll(request.toSingleCameraFormFields())
      ..files.add(
        await http.MultipartFile.fromPath('video', request.videoPath),
      );

    try {
      final streamedResponse = await client.send(upload).timeout(timeout);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw SingleCameraAnalysisException(_errorMessage(response));
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const SingleCameraAnalysisException(
          'The AI Engine returned an invalid response.',
        );
      }

      final summary = SingleCameraPoseSummary.fromJson(decoded);
      if (!summary.hasExpectedScientificBoundary) {
        throw const SingleCameraAnalysisException(
          'The AI response does not satisfy the single-camera safety boundary.',
        );
      }

      return summary;
    } on TimeoutException {
      throw const SingleCameraAnalysisException('The pose analysis timed out.');
    } on SingleCameraAnalysisException {
      rethrow;
    } on FormatException {
      throw const SingleCameraAnalysisException(
        'The AI Engine returned an incompatible response.',
      );
    } catch (error) {
      throw SingleCameraAnalysisException(
        'The AI Engine could not be reached: $error',
      );
    }
  }

  String _errorMessage(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        final detail = decoded['detail'];
        if (detail is String && detail.isNotEmpty) {
          return detail;
        }
      }
    } on FormatException {
      // Fall through to a bounded status message.
    }

    return 'The AI Engine rejected the video (HTTP ${response.statusCode}).';
  }
}
