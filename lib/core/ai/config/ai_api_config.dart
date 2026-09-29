class AiApiConfig {
  const AiApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'JUDO_MIND_AI_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );

  static Uri singleCameraPoseSummaryUri() {
    return Uri.parse(
      baseUrl,
    ).resolve('/v1/analysis/single-camera/pose-summary');
  }

  static Uri singleAttemptV2AVideoUri() {
    return Uri.parse(
      baseUrl,
    ).resolve('/v2a/analysis/single-camera/uchi-mata/single-attempt/video');
  }

  static Uri guidedReviewPrepareUri() => Uri.parse(baseUrl).resolve(
    '/v2a/analysis/single-camera/uchi-mata/single-attempt/guided/prepare',
  );

  static Uri guidedTimingManifestUri() => Uri.parse(baseUrl).resolve(
    '/v2a/analysis/single-camera/uchi-mata/single-attempt/guided/timing-manifest',
  );

  static Uri guidedBoundaryPreviewUri() => Uri.parse(baseUrl).resolve(
    '/v2a/analysis/single-camera/uchi-mata/single-attempt/guided/boundary-preview',
  );

  static Uri guidedReviewAnalyzeUri() => Uri.parse(baseUrl).resolve(
    '/v2a/analysis/single-camera/uchi-mata/single-attempt/guided/analyze',
  );
}
