import 'package:flutter/material.dart';

import '../../../../core/design_system/icons/judo_icons.dart';
import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';
import '../../../../core/widgets/judo_card.dart';

class TechniquePhaseVisualItem {
  const TechniquePhaseVisualItem({
    required this.id,
    required this.label,
    required this.instruction,
  });

  final String id;
  final String label;
  final String instruction;
}

/// A progressive, model-driven Kuzushi/Tsukuri/Kake learning artifact.
///
/// This intentionally does not reuse the biomechanics CustomPainter. It shows
/// only approved phase text supplied by the technique model and makes no
/// automatic phase-detection claim.
class TechniquePhaseVisualGuide extends StatefulWidget {
  const TechniquePhaseVisualGuide({super.key, required this.phases});

  final List<TechniquePhaseVisualItem> phases;

  @override
  State<TechniquePhaseVisualGuide> createState() =>
      _TechniquePhaseVisualGuideState();
}

class _TechniquePhaseVisualGuideState extends State<TechniquePhaseVisualGuide> {
  int _selectedIndex = 0;

  @override
  void didUpdateWidget(covariant TechniquePhaseVisualGuide oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_selectedIndex >= widget.phases.length) {
      _selectedIndex = 0;
    }
  }

  Color _phaseColor(int index) {
    return switch (index % 3) {
      0 => JudoColors.success,
      1 => JudoColors.primary,
      _ => JudoColors.gold,
    };
  }

  IconData _phaseIcon(int index) {
    return switch (index % 3) {
      0 => JudoIcons.kuzushi,
      1 => JudoIcons.tsukuri,
      _ => JudoIcons.kake,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (widget.phases.isEmpty) {
      return const SizedBox.shrink();
    }

    final selected = widget.phases[_selectedIndex];
    final selectedColor = _phaseColor(_selectedIndex);

    return Semantics(
      container: true,
      child: Column(
        key: const ValueKey<String>('technical-phase-progression'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 420;
              final selectors = List<Widget>.generate(widget.phases.length, (
                index,
              ) {
                final phase = widget.phases[index];
                final color = _phaseColor(index);
                final active = index == _selectedIndex;

                return Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                      end: index == widget.phases.length - 1
                          ? 0
                          : JudoSpacing.xs,
                    ),
                    child: Semantics(
                      button: true,
                      selected: active,
                      label: '${index + 1}. ${phase.label}',
                      child: InkWell(
                        key: ValueKey<String>('technical-phase-${phase.id}'),
                        onTap: () => setState(() => _selectedIndex = index),
                        borderRadius: BorderRadius.circular(JudoRadius.md),
                        child: AnimatedContainer(
                          duration: JudoAnimation.fast,
                          padding: const EdgeInsets.symmetric(
                            horizontal: JudoSpacing.sm,
                            vertical: JudoSpacing.md,
                          ),
                          decoration: BoxDecoration(
                            color: active
                                ? color.withValues(alpha: 0.16)
                                : JudoColors.surface,
                            borderRadius: BorderRadius.circular(JudoRadius.md),
                            border: Border.all(
                              color: active ? color : JudoColors.border,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                _phaseIcon(index),
                                color: color,
                                size: JudoIconSize.sm,
                              ),
                              const SizedBox(height: JudoSpacing.xs),
                              Text(
                                phase.label,
                                maxLines: compact ? 2 : 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: JudoTypography.labelMedium.copyWith(
                                  color: active
                                      ? color
                                      : JudoColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              });

              return Row(children: selectors);
            },
          ),
          const SizedBox(height: JudoSpacing.md),
          JudoCard(
            key: ValueKey<String>('technical-phase-detail-${selected.id}'),
            borderColor: selectedColor.withValues(alpha: 0.48),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selectedColor.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(JudoRadius.sm),
                  ),
                  child: Text(
                    '${_selectedIndex + 1}',
                    style: JudoTypography.titleMedium.copyWith(
                      color: selectedColor,
                    ),
                  ),
                ),
                const SizedBox(width: JudoSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selected.label,
                        style: JudoTypography.titleMedium.copyWith(
                          color: selectedColor,
                        ),
                      ),
                      const SizedBox(height: JudoSpacing.sm),
                      Text(
                        selected.instruction,
                        style: JudoTypography.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
