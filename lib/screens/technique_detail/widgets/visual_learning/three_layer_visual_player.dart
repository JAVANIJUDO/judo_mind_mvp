import 'package:flutter/material.dart';

import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../models/technique_visual_learning_model.dart';
import 'uchi_mata_three_layer_painter.dart';

/// ----------------------------------------------------------------
/// Judo Mind Super App
/// Three-Layer Visual Learning Player
/// Version: 1.0.0
/// ----------------------------------------------------------------
///
/// Blue:
/// Footwork and body movement
///
/// Gold:
/// Grip and upper-body control
///
/// Green:
/// Force, balance and biomechanics
class ThreeLayerVisualPlayer extends StatefulWidget {
  final TechniqueVisualSequence sequence;

  const ThreeLayerVisualPlayer({super.key, required this.sequence});

  @override
  State<ThreeLayerVisualPlayer> createState() => _ThreeLayerVisualPlayerState();
}

class _ThreeLayerVisualPlayerState extends State<ThreeLayerVisualPlayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool _movementVisible = true;
  bool _controlVisible = true;
  bool _biomechanicsVisible = true;

  double _playbackSpeed = 1;

  @override
  void initState() {
    super.initState();
    _createController();
  }

  void _createController() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.sequence.durationMilliseconds),
    );

    if (widget.sequence.loop) {
      _controller.repeat();
    } else {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant ThreeLayerVisualPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.sequence.id != widget.sequence.id) {
      _controller.dispose();
      _playbackSpeed = 1;
      _createController();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayback() {
    setState(() {
      if (_controller.isAnimating) {
        _controller.stop();
      } else if (widget.sequence.loop) {
        _controller.repeat();
      } else {
        _controller.forward(from: _controller.value);
      }
    });
  }

  void _restart() {
    _controller.value = 0;

    if (widget.sequence.loop) {
      _controller.repeat();
    } else {
      _controller.forward();
    }

    setState(() {});
  }

  void _changeSpeed(double speed) {
    final wasAnimating = _controller.isAnimating;

    _controller.stop();

    setState(() {
      _playbackSpeed = speed;

      _controller.duration = Duration(
        milliseconds: (widget.sequence.durationMilliseconds / speed).round(),
      );
    });

    if (wasAnimating) {
      if (widget.sequence.loop) {
        _controller.repeat();
      } else {
        _controller.forward();
      }
    }
  }

  Color _layerColor(TechniqueVisualLayerType type) {
    switch (type) {
      case TechniqueVisualLayerType.movement:
        return JudoColors.primary;

      case TechniqueVisualLayerType.control:
        return JudoColors.gold;

      case TechniqueVisualLayerType.biomechanics:
        return JudoColors.success;
    }
  }

  String _layerLabel(TechniqueVisualLayerType type) {
    switch (type) {
      case TechniqueVisualLayerType.movement:
        return 'Movement';

      case TechniqueVisualLayerType.control:
        return 'Control';

      case TechniqueVisualLayerType.biomechanics:
        return 'Force';
    }
  }

  bool _isLayerVisible(TechniqueVisualLayerType type) {
    switch (type) {
      case TechniqueVisualLayerType.movement:
        return _movementVisible;

      case TechniqueVisualLayerType.control:
        return _controlVisible;

      case TechniqueVisualLayerType.biomechanics:
        return _biomechanicsVisible;
    }
  }

  void _toggleLayer(TechniqueVisualLayerType type) {
    setState(() {
      switch (type) {
        case TechniqueVisualLayerType.movement:
          _movementVisible = !_movementVisible;
          break;

        case TechniqueVisualLayerType.control:
          _controlVisible = !_controlVisible;
          break;

        case TechniqueVisualLayerType.biomechanics:
          _biomechanicsVisible = !_biomechanicsVisible;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: JudoColors.surface,
        borderRadius: BorderRadius.circular(JudoRadius.lg),
        border: Border.all(color: JudoColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(JudoSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.sequence.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: JudoColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: JudoSpacing.sm),
                Text(
                  widget.sequence.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: JudoColors.textSecondary,
                  ),
                ),
                const SizedBox(height: JudoSpacing.lg),
                Wrap(
                  spacing: JudoSpacing.sm,
                  runSpacing: JudoSpacing.sm,
                  children: TechniqueVisualLayerType.values.map((type) {
                    final selected = _isLayerVisible(type);

                    final color = _layerColor(type);

                    return FilterChip(
                      selected: selected,
                      showCheckmark: false,
                      label: Text(_layerLabel(type)),
                      avatar: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      selectedColor: color.withValues(alpha: 0.18),
                      backgroundColor: JudoColors.surfaceVariant,
                      side: BorderSide(
                        color: selected ? color : JudoColors.border,
                      ),
                      labelStyle: TextStyle(
                        color: selected ? color : JudoColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                      onSelected: (_) {
                        _toggleLayer(type);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          AspectRatio(
            aspectRatio: 1.15,
            child: Container(
              width: double.infinity,
              color: JudoColors.background,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: UchiMataThreeLayerPainter(
                      progress: _controller.value,
                      showMovement: _movementVisible,
                      showControl: _controlVisible,
                      showBiomechanics: _biomechanicsVisible,
                    ),
                  );
                },
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(JudoSpacing.lg),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: _restart,
                      color: JudoColors.textPrimary,
                      icon: const Icon(Icons.replay_rounded),
                    ),
                    Expanded(
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Slider(
                            value: _controller.value,
                            activeColor: JudoColors.primary,
                            inactiveColor: JudoColors.surfaceVariant,
                            onChanged: (value) {
                              _controller.value = value;
                            },
                          );
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: _togglePlayback,
                      color: JudoColors.primary,
                      icon: Icon(
                        _controller.isAnimating
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: JudoSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _SpeedButton(
                      label: '0.5×',
                      selected: _playbackSpeed == 0.5,
                      onTap: () => _changeSpeed(0.5),
                    ),
                    const SizedBox(width: JudoSpacing.sm),
                    _SpeedButton(
                      label: '1×',
                      selected: _playbackSpeed == 1,
                      onTap: () => _changeSpeed(1),
                    ),
                    const SizedBox(width: JudoSpacing.sm),
                    _SpeedButton(
                      label: '1.5×',
                      selected: _playbackSpeed == 1.5,
                      onTap: () => _changeSpeed(1.5),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SpeedButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SpeedButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(JudoRadius.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: JudoSpacing.md,
          vertical: JudoSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: selected
              ? JudoColors.primary.withValues(alpha: 0.18)
              : JudoColors.surfaceVariant,
          borderRadius: BorderRadius.circular(JudoRadius.sm),
          border: Border.all(
            color: selected ? JudoColors.primary : JudoColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? JudoColors.primary : JudoColors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
