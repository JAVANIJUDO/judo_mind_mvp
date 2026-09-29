import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/ai/analysis/single_attempt_v2a_service.dart';
import '../../core/ai/config/ai_api_config.dart';
import '../../models/single_attempt_analysis_v2a.dart';
import '../../models/single_attempt_v2a_request.dart';

class HttpSingleAttemptV2AService implements SingleAttemptV2AService {
  HttpSingleAttemptV2AService({
    required this.client,
    Uri? endpoint,
    this.timeout = const Duration(minutes: 2),
  }) : _endpoint = endpoint ?? AiApiConfig.singleAttemptV2AVideoUri();

  final http.Client client;
  final Uri _endpoint;
  final Duration timeout;

  @override
  Future<SingleAttemptAnalysisV2A> analyzeReviewedVideo(
    SingleAttemptV2ARequest request,
  ) async {
    if (!request.isValid) {
      throw const SingleAttemptV2AException(
        'The reviewed single-attempt request is incomplete.',
      );
    }

    try {
      final upload = http.MultipartRequest('POST', _endpoint)
        ..fields['review_json'] = jsonEncode(request.toReviewJson())
        ..files.add(
          await http.MultipartFile.fromPath('video', request.videoPath),
        );
      final streamedResponse = await client.send(upload).timeout(timeout);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw SingleAttemptV2AException(_errorMessage(response));
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const SingleAttemptV2AException(
          'The AI Engine returned an invalid V2A response.',
        );
      }

      final result = SingleAttemptAnalysisV2A.fromJson(decoded);
      if (!result.hasExpectedScientificBoundary) {
        throw const SingleAttemptV2AException(
          'The V2A response does not satisfy the scientific safety boundary.',
        );
      }
      if (!result.matchesReviewedRequest(request)) {
        throw const SingleAttemptV2AException(
          'The V2A response does not match the reviewed request.',
        );
      }

      return result;
    } on TimeoutException {
      throw const SingleAttemptV2AException(
        'The selected-frame V2A analysis timed out.',
      );
    } on SingleAttemptV2AException {
      rethrow;
    } on FormatException {
      throw const SingleAttemptV2AException(
        'The AI Engine returned an incompatible V2A response.',
      );
    } on FileSystemException {
      throw const SingleAttemptV2AException(
        'The selected video file could not be opened.',
      );
    } catch (_) {
      throw const SingleAttemptV2AException(
        'The V2A AI Engine could not be reached. Check the development '
        'connection and try again.',
      );
    }
  }

  String _errorMessage(http.Response response) {
    if (response.statusCode == 404) {
      return 'The V2A endpoint was not found (HTTP 404). '
          'Check the AI Engine version and JUDO_MIND_AI_BASE_URL.';
    }

    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        final detail = decoded['detail'];
        if (detail is String && detail.isNotEmpty) {
          return detail;
        }
      }
    } on FormatException {
      // Fall through to the bounded status message.
    }

    return 'The AI Engine rejected the reviewed attempt '
        '(HTTP ${response.statusCode}).';
  }
}
