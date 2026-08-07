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
}
