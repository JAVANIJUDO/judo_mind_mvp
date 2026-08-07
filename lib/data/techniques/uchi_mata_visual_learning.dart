import '../../models/technique_visual_learning_model.dart';

/// ----------------------------------------------------------------
/// Judo Mind Super App
/// Uchi Mata Three-Layer Visual Learning Data
/// Version: 1.0.0
/// ----------------------------------------------------------------
///
/// Color architecture:
///
/// Blue:
/// Footwork, entry and body movement
///
/// Gold:
/// Grip, pulling action and upper-body control
///
/// Green:
/// Force direction, balance and biomechanics

const TechniqueVisualLearningPlan
uchiMataVisualLearningPlan = TechniqueVisualLearningPlan(
  techniqueId: '001',
  sequences: [
    // -----------------------------------------------------------
    // Technical execution
    // -----------------------------------------------------------
    TechniqueVisualSequence(
      id: 'uchi_mata_execution',
      title: 'Uchi Mata Execution',
      description:
          'Understand the complete throw by viewing footwork, grip control and biomechanical force as synchronized visual layers.',
      learningType: TechniqueVisualLearningType.technicalExecution,
      durationMilliseconds: 6000,
      layers: [
        TechniqueVisualLayer(
          id: 'uchi_mata_execution_movement',
          title: 'Footwork & Entry',
          shortInstruction:
              'Step inside, turn the hips and position the attacking leg between the opponent’s legs.',
          type: TechniqueVisualLayerType.movement,
          color: TechniqueVisualLayerColor.blue,
          mediaType: TechniqueVisualMediaType.customPainter,
          coachingCues: [
            'Enter close to the opponent',
            'Keep a stable supporting leg',
            'Turn continuously without stopping',
          ],
          highlightedBodyParts: ['Supporting foot', 'Attacking leg', 'Hips'],
        ),
        TechniqueVisualLayer(
          id: 'uchi_mata_execution_control',
          title: 'Grip & Upper-Body Control',
          shortInstruction:
              'Pull the sleeve forward and upward while guiding the lapel across the throwing direction.',
          type: TechniqueVisualLayerType.control,
          color: TechniqueVisualLayerColor.gold,
          mediaType: TechniqueVisualMediaType.customPainter,
          coachingCues: [
            'Maintain sleeve tension',
            'Lift with the lapel hand',
            'Rotate shoulders with the hips',
          ],
          highlightedBodyParts: ['Sleeve hand', 'Lapel hand', 'Shoulders'],
        ),
        TechniqueVisualLayer(
          id: 'uchi_mata_execution_biomechanics',
          title: 'Force & Balance',
          shortInstruction:
              'Transfer force upward and forward while moving the opponent’s center of gravity beyond the support base.',
          type: TechniqueVisualLayerType.biomechanics,
          color: TechniqueVisualLayerColor.green,
          mediaType: TechniqueVisualMediaType.customPainter,
          coachingCues: [
            'Create forward kuzushi',
            'Lift through the inner thigh',
            'Continue force in a circular direction',
          ],
          highlightedBodyParts: ['Center of gravity', 'Inner thigh', 'Core'],
        ),
      ],
    ),

    // -----------------------------------------------------------
    // Biomechanics
    // -----------------------------------------------------------
    TechniqueVisualSequence(
      id: 'uchi_mata_biomechanics',
      title: 'Uchi Mata Biomechanics',
      description:
          'Explore posture, force direction and center-of-gravity movement throughout the throw.',
      learningType: TechniqueVisualLearningType.biomechanics,
      durationMilliseconds: 6500,
      layers: [
        TechniqueVisualLayer(
          id: 'uchi_mata_biomechanics_movement',
          title: 'Body Path',
          shortInstruction:
              'Follow the rotational path of the feet, hips and attacking leg.',
          type: TechniqueVisualLayerType.movement,
          color: TechniqueVisualLayerColor.blue,
          mediaType: TechniqueVisualMediaType.customPainter,
          coachingCues: [
            'Keep the supporting foot active',
            'Position hips under the movement line',
            'Extend the attacking leg naturally',
          ],
          highlightedBodyParts: ['Feet', 'Knees', 'Hips'],
        ),
        TechniqueVisualLayer(
          id: 'uchi_mata_biomechanics_control',
          title: 'Kinetic Chain',
          shortInstruction:
              'Connect the pulling action of the arms with trunk rotation and hip extension.',
          type: TechniqueVisualLayerType.control,
          color: TechniqueVisualLayerColor.gold,
          mediaType: TechniqueVisualMediaType.customPainter,
          coachingCues: [
            'Hands initiate direction',
            'Trunk transfers rotational force',
            'Hips and leg complete the chain',
          ],
          highlightedBodyParts: ['Hands', 'Shoulders', 'Trunk'],
        ),
        TechniqueVisualLayer(
          id: 'uchi_mata_biomechanics_force',
          title: 'Force & Center of Gravity',
          shortInstruction:
              'Observe the upward lifting force, forward kuzushi and circular finishing force.',
          type: TechniqueVisualLayerType.biomechanics,
          color: TechniqueVisualLayerColor.green,
          mediaType: TechniqueVisualMediaType.customPainter,
          coachingCues: [
            'Move the opponent outside the support base',
            'Direct force upward before rotation',
            'Maintain balance over the supporting leg',
          ],
          highlightedBodyParts: [
            'Center of gravity',
            'Support base',
            'Force direction',
          ],
        ),
      ],
    ),

    // -----------------------------------------------------------
    // Shadow training
    // -----------------------------------------------------------
    TechniqueVisualSequence(
      id: 'uchi_mata_shadow_training',
      title: 'Uchi Mata Shadow Training',
      description:
          'Practice the complete movement pattern without a partner by following the three synchronized layers.',
      learningType: TechniqueVisualLearningType.shadowTraining,
      durationMilliseconds: 5000,
      layers: [
        TechniqueVisualLayer(
          id: 'uchi_mata_shadow_movement',
          title: 'Entry Pattern',
          shortInstruction:
              'Repeat the step, pivot and attacking-leg path with controlled rhythm.',
          type: TechniqueVisualLayerType.movement,
          color: TechniqueVisualLayerColor.blue,
          mediaType: TechniqueVisualMediaType.customPainter,
          coachingCues: [
            'Start slowly',
            'Keep identical entry distance',
            'Return to the starting stance',
          ],
          highlightedBodyParts: ['Feet', 'Hips', 'Attacking leg'],
        ),
        TechniqueVisualLayer(
          id: 'uchi_mata_shadow_control',
          title: 'Virtual Grip Action',
          shortInstruction:
              'Simulate sleeve pulling and lapel lifting during every entry.',
          type: TechniqueVisualLayerType.control,
          color: TechniqueVisualLayerColor.gold,
          mediaType: TechniqueVisualMediaType.customPainter,
          coachingCues: [
            'Keep elbows active',
            'Coordinate hands with the pivot',
            'Finish with shoulder rotation',
          ],
          highlightedBodyParts: ['Hands', 'Elbows', 'Shoulders'],
        ),
        TechniqueVisualLayer(
          id: 'uchi_mata_shadow_biomechanics',
          title: 'Balance & Rhythm',
          shortInstruction:
              'Maintain balance on the supporting leg while reproducing the lifting and rotational rhythm.',
          type: TechniqueVisualLayerType.biomechanics,
          color: TechniqueVisualLayerColor.green,
          mediaType: TechniqueVisualMediaType.customPainter,
          coachingCues: [
            'Stabilize the supporting knee',
            'Engage the core',
            'Control the return movement',
          ],
          highlightedBodyParts: ['Supporting leg', 'Core', 'Center of gravity'],
        ),
      ],
    ),

    // -----------------------------------------------------------
    // Strength and conditioning
    // -----------------------------------------------------------
    TechniqueVisualSequence(
      id: 'uchi_mata_conditioning',
      title: 'Uchi Mata Strength & Conditioning',
      description:
          'Understand the movement, muscular control and force requirements of technique-specific conditioning.',
      learningType: TechniqueVisualLearningType.strengthConditioning,
      durationMilliseconds: 5500,
      layers: [
        TechniqueVisualLayer(
          id: 'uchi_mata_conditioning_movement',
          title: 'Exercise Movement',
          shortInstruction:
              'Follow the correct single-leg stance, hip extension and rotational movement.',
          type: TechniqueVisualLayerType.movement,
          color: TechniqueVisualLayerColor.blue,
          mediaType: TechniqueVisualMediaType.customPainter,
          coachingCues: [
            'Use controlled range of motion',
            'Keep the supporting knee aligned',
            'Avoid excessive trunk leaning',
          ],
          highlightedBodyParts: ['Supporting leg', 'Hips', 'Trunk'],
        ),
        TechniqueVisualLayer(
          id: 'uchi_mata_conditioning_control',
          title: 'Posture & Joint Control',
          shortInstruction:
              'Maintain stable posture and coordinated upper-body rotation throughout the exercise.',
          type: TechniqueVisualLayerType.control,
          color: TechniqueVisualLayerColor.gold,
          mediaType: TechniqueVisualMediaType.customPainter,
          coachingCues: [
            'Keep shoulders connected to hip rotation',
            'Control the knee position',
            'Maintain neutral posture',
          ],
          highlightedBodyParts: ['Shoulders', 'Spine', 'Knee'],
        ),
        TechniqueVisualLayer(
          id: 'uchi_mata_conditioning_biomechanics',
          title: 'Muscles & Force',
          shortInstruction:
              'Visualize the primary muscles and the direction of force required for Uchi Mata.',
          type: TechniqueVisualLayerType.biomechanics,
          color: TechniqueVisualLayerColor.green,
          mediaType: TechniqueVisualMediaType.customPainter,
          coachingCues: [
            'Develop unilateral leg stability',
            'Strengthen hip extension',
            'Train rotational core power',
          ],
          highlightedBodyParts: [
            'Gluteal muscles',
            'Hamstrings',
            'Adductors',
            'Core',
          ],
        ),
      ],
    ),
  ],
);
