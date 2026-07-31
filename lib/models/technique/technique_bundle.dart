import 'biomechanics_model.dart';
import 'competition_model.dart';
import 'conditioning_model.dart';
import 'mastery_model.dart';
import 'shadow_training_model.dart';
import 'technique_ai_model.dart';
import 'technique_core_model.dart';
import 'technique_media_model.dart';
import 'technique_progress_model.dart';
import 'technique_science_model.dart';
import 'technique_training_model.dart';
import 'world_execution_model.dart';

/// Aggregates all technique-related models in one place.
/// This class is for architecture and future backend integration.
/// Existing screens do not need to use it yet.
class TechniqueBundle {
  final TechniqueCoreModel core;
  final TechniqueMediaModel media;
  final TechniqueScienceModel science;
  final TechniqueTrainingModel training;
  final BiomechanicsModel biomechanics;
  final ConditioningModel conditioning;
  final ShadowTrainingModel shadowTraining;
  final WorldExecutionModel worldExecution;
  final MasteryModel mastery;
  final CompetitionModel? competition;
  final TechniqueAIModel? ai;
  final TechniqueProgressModel? progress;

  const TechniqueBundle({
    required this.core,
    required this.media,
    required this.science,
    required this.training,
    required this.biomechanics,
    required this.conditioning,
    required this.shadowTraining,
    required this.worldExecution,
    required this.mastery,
    this.competition,
    this.ai,
    this.progress,
  });
}