/// ----------------------------------------------------------------
/// Judo Mind Super App
/// Model: Media Analysis Metadata
/// Module: AI 360° Technique Analysis
/// Version: 1.0.0
/// ----------------------------------------------------------------
///
/// Stores tactical and biomechanical information
/// extracted from technique videos.
///
/// Used by:
/// - Sensi Bot AI Lab
/// - Competition Analysis
/// - Top Execution Review
/// - Biomechanics Module
class MediaAnalysisMetadata {
  /// Opponent grip configuration.
  ///
  /// Example:
  /// Right grip vs Left grip
  final String? opponentGuard;

  /// Opponent body position and stance.
  ///
  /// Example:
  /// Defensive high posture
  final String? opponentStance;

  /// Exact moment when attack begins.
  ///
  /// Example:
  /// After opponent reaction
  final String? attackTiming;

  /// Defensive response from opponent.
  ///
  /// Example:
  /// Blocking hip rotation
  final String? defenseReaction;

  /// Direction of balance breaking.
  ///
  /// Example:
  /// Forward-right kuzushi
  final String? kuzushiDirection;

  /// Balance weakness analysis.
  ///
  /// Example:
  /// Reduced base stability
  final String? balanceAnalysis;

  /// Entry angle of the technique.
  ///
  /// Example:
  /// 45 degree rotation entry
  final String? entryAngle;

  /// Hip position during execution.
  final String? hipPosition;

  /// Foot placement details.
  final String? footPlacement;

  /// Push-pull dynamics.
  ///
  /// Example:
  /// Sleeve pull + opponent forward pressure
  final String? pushPullDynamic;

  const MediaAnalysisMetadata({
    this.opponentGuard,
    this.opponentStance,
    this.attackTiming,
    this.defenseReaction,
    this.kuzushiDirection,
    this.balanceAnalysis,
    this.entryAngle,
    this.hipPosition,
    this.footPlacement,
    this.pushPullDynamic,
  });

  bool get hasAnalysisData {
    return opponentGuard != null ||
        opponentStance != null ||
        attackTiming != null ||
        defenseReaction != null ||
        kuzushiDirection != null ||
        balanceAnalysis != null ||
        entryAngle != null ||
        hipPosition != null ||
        footPlacement != null ||
        pushPullDynamic != null;
  }

  MediaAnalysisMetadata copyWith({
    String? opponentGuard,
    String? opponentStance,
    String? attackTiming,
    String? defenseReaction,
    String? kuzushiDirection,
    String? balanceAnalysis,
    String? entryAngle,
    String? hipPosition,
    String? footPlacement,
    String? pushPullDynamic,
  }) {
    return MediaAnalysisMetadata(
      opponentGuard:
          opponentGuard ?? this.opponentGuard,
      opponentStance:
          opponentStance ?? this.opponentStance,
      attackTiming:
          attackTiming ?? this.attackTiming,
      defenseReaction:
          defenseReaction ?? this.defenseReaction,
      kuzushiDirection:
          kuzushiDirection ?? this.kuzushiDirection,
      balanceAnalysis:
          balanceAnalysis ?? this.balanceAnalysis,
      entryAngle:
          entryAngle ?? this.entryAngle,
      hipPosition:
          hipPosition ?? this.hipPosition,
      footPlacement:
          footPlacement ?? this.footPlacement,
      pushPullDynamic:
          pushPullDynamic ?? this.pushPullDynamic,
    );
  }
}