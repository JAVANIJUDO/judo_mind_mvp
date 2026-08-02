/// =============================================================
/// Judo Mind Design System
/// Illustration Type Registry
///
/// Version: 1.0.0
///
/// Every approved Judo Mind illustration must have a semantic type.
/// Feature widgets must reference this registry instead of directly
/// referencing asset paths.
/// =============================================================

enum JudoIllustrationType {
  sensiBot,
  quiz,
  training,
  competition,
  mastery,
  tacticalIntelligence,
  technicalAnalysis,
  biomechanics,
  gripFighting,
  balanceAnalysis,
  fightIntelligence,
  videoAnalysis,
  champion,
  combination,
  mistakesAndSafety,
}

extension JudoIllustrationTypeMetadata
    on JudoIllustrationType {
  String get semanticLabel {
    switch (this) {
      case JudoIllustrationType.sensiBot:
        return 'Sensi Bot digital judo coach';

      case JudoIllustrationType.quiz:
        return 'Judo knowledge quiz';

      case JudoIllustrationType.training:
        return 'Judo technique training';

      case JudoIllustrationType.competition:
        return 'Judo competition analysis';

      case JudoIllustrationType.mastery:
        return 'Judo technique mastery';

      case JudoIllustrationType.tacticalIntelligence:
        return 'Judo tactical intelligence';

      case JudoIllustrationType.technicalAnalysis:
        return 'Judo technical analysis';

      case JudoIllustrationType.biomechanics:
        return 'Judo biomechanics analysis';

      case JudoIllustrationType.gripFighting:
        return 'Judo grip fighting';

      case JudoIllustrationType.balanceAnalysis:
        return 'Judo balance analysis';

      case JudoIllustrationType.fightIntelligence:
        return 'Judo fight intelligence';

      case JudoIllustrationType.videoAnalysis:
        return 'Judo video analysis';

      case JudoIllustrationType.champion:
        return 'Judo champion';

      case JudoIllustrationType.combination:
        return 'Judo technique combination';

      case JudoIllustrationType.mistakesAndSafety:
        return 'Judo mistakes and safety';
    }
  }

  String get assetFileName {
    switch (this) {
      case JudoIllustrationType.sensiBot:
        return 'sensi_bot.svg';

      case JudoIllustrationType.quiz:
        return 'quiz.svg';

      case JudoIllustrationType.training:
        return 'training.svg';

      case JudoIllustrationType.competition:
        return 'competition.svg';

      case JudoIllustrationType.mastery:
        return 'mastery.svg';

      case JudoIllustrationType.tacticalIntelligence:
        return 'tactical_intelligence.svg';

      case JudoIllustrationType.technicalAnalysis:
        return 'technical_analysis.svg';

      case JudoIllustrationType.biomechanics:
        return 'biomechanics.svg';

      case JudoIllustrationType.gripFighting:
        return 'grip_fighting.svg';

      case JudoIllustrationType.balanceAnalysis:
        return 'balance_analysis.svg';

      case JudoIllustrationType.fightIntelligence:
        return 'fight_intelligence.svg';

      case JudoIllustrationType.videoAnalysis:
        return 'video_analysis.svg';

      case JudoIllustrationType.champion:
        return 'champion.svg';

      case JudoIllustrationType.combination:
        return 'combination.svg';

      case JudoIllustrationType.mistakesAndSafety:
        return 'mistakes_and_safety.svg';
    }
  }

  String get assetPath {
    return 'assets/illustrations/judo/$assetFileName';
  }
}