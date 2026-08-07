// ----------------------------------------------------------------
// Judo Mind Super App
// Model: Three-Layer Visual Learning Architecture
// Reference Technique: Uchi Mata
// Version: 1.0.0
// ----------------------------------------------------------------
//
// A technique movement is displayed through three synchronized,
// color-coded animation layers.
//
// Layer 1: Footwork and body movement
// Layer 2: Grip and upper-body action
// Layer 3: Force, balance and biomechanics
//
// The layers can be played individually or together.

enum TechniqueVisualLearningType {
  technicalExecution,
  biomechanics,
  shadowTraining,
  strengthConditioning,
  mobility,
}

enum TechniqueVisualLayerType { movement, control, biomechanics }

enum TechniqueVisualLayerColor { blue, gold, green }

enum TechniqueVisualMediaType {
  customPainter,
  imageSequence,
  animatedImage,
  lottie,
  rive,
  video,
  threeDimensional,
}

class TechniqueVisualLayer {
  final String id;
  final String title;
  final String shortInstruction;

  final TechniqueVisualLayerType type;
  final TechniqueVisualLayerColor color;

  final TechniqueVisualMediaType mediaType;

  final String? imageAsset;
  final String? animationAsset;
  final String? videoUrl;

  final List<String> coachingCues;
  final List<String> highlightedBodyParts;

  final bool isEnabledByDefault;

  const TechniqueVisualLayer({
    required this.id,
    required this.title,
    required this.shortInstruction,
    required this.type,
    required this.color,
    required this.mediaType,
    this.imageAsset,
    this.animationAsset,
    this.videoUrl,
    this.coachingCues = const [],
    this.highlightedBodyParts = const [],
    this.isEnabledByDefault = true,
  });

  bool get hasMedia {
    return (imageAsset?.trim().isNotEmpty ?? false) ||
        (animationAsset?.trim().isNotEmpty ?? false) ||
        (videoUrl?.trim().isNotEmpty ?? false) ||
        mediaType == TechniqueVisualMediaType.customPainter;
  }
}

class TechniqueVisualSequence {
  final String id;
  final String title;
  final String description;

  final TechniqueVisualLearningType learningType;

  final String? backgroundAsset;
  final String? thumbnailAsset;

  final List<TechniqueVisualLayer> layers;

  final int durationMilliseconds;
  final bool loop;
  final bool allowLayerToggle;
  final bool allowPlaybackSpeedControl;

  const TechniqueVisualSequence({
    required this.id,
    required this.title,
    required this.description,
    required this.learningType,
    required this.layers,
    this.backgroundAsset,
    this.thumbnailAsset,
    this.durationMilliseconds = 5000,
    this.loop = true,
    this.allowLayerToggle = true,
    this.allowPlaybackSpeedControl = true,
  });

  bool get hasThreeLayerArchitecture {
    final layerTypes = layers.map((layer) => layer.type).toSet();

    return layers.length == 3 &&
        layerTypes.contains(TechniqueVisualLayerType.movement) &&
        layerTypes.contains(TechniqueVisualLayerType.control) &&
        layerTypes.contains(TechniqueVisualLayerType.biomechanics);
  }

  bool get isReady {
    return title.trim().isNotEmpty &&
        layers.isNotEmpty &&
        layers.every((layer) => layer.hasMedia);
  }

  TechniqueVisualLayer? layerByType(TechniqueVisualLayerType type) {
    for (final layer in layers) {
      if (layer.type == type) {
        return layer;
      }
    }

    return null;
  }
}

class TechniqueVisualLearningPlan {
  final String techniqueId;
  final List<TechniqueVisualSequence> sequences;

  const TechniqueVisualLearningPlan({
    required this.techniqueId,
    this.sequences = const [],
  });

  List<TechniqueVisualSequence> sequencesByType(
    TechniqueVisualLearningType type,
  ) {
    return sequences
        .where((sequence) => sequence.learningType == type)
        .toList(growable: false);
  }

  bool get isEmpty => sequences.isEmpty;

  bool get isNotEmpty => sequences.isNotEmpty;

  int get totalSequences => sequences.length;
}
