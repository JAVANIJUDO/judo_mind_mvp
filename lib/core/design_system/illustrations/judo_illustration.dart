import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/judo_design_tokens.dart';
import 'judo_illustration_type.dart';

/// =============================================================
/// Judo Mind Design System
/// Custom Illustration Renderer
///
/// Version: 1.0.0
///
/// Initial supported illustrations:
/// - Sensi Bot
/// - Quiz
/// - Training
/// - Competition
/// - Mastery
///
/// The current implementation uses CustomPainter.
/// Future SVG assets can replace the internal renderer without
/// changing feature screens.
/// =============================================================

class JudoIllustration extends StatelessWidget {
  final JudoIllustrationType type;
  final double size;
  final Color? accentColor;
  final bool showBackground;
  final bool showBorder;
  final String? semanticLabel;

  const JudoIllustration({
    super.key,
    required this.type,
    this.size = 72,
    this.accentColor,
    this.showBackground = true,
    this.showBorder = false,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        accentColor ?? _defaultAccentColor(type);

    return Semantics(
      image: true,
      label: semanticLabel ?? type.semanticLabel,
      child: SizedBox.square(
        dimension: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: showBackground
                ? color.withValues(alpha: 0.10)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(
              size * 0.24,
            ),
            border: showBorder
                ? Border.all(
                    color: color.withValues(alpha: 0.28),
                  )
                : null,
          ),
          child: Padding(
            padding: EdgeInsets.all(size * 0.12),
            child: CustomPaint(
              painter: _JudoIllustrationPainter(
                type: type,
                color: color,
              ),
              size: Size.square(size),
            ),
          ),
        ),
      ),
    );
  }

  Color _defaultAccentColor(
    JudoIllustrationType illustrationType,
  ) {
    switch (illustrationType) {
      case JudoIllustrationType.sensiBot:
      case JudoIllustrationType.fightIntelligence:
      case JudoIllustrationType.videoAnalysis:
        return JudoColors.primary;

      case JudoIllustrationType.quiz:
      case JudoIllustrationType.mastery:
      case JudoIllustrationType.champion:
        return JudoColors.gold;

      case JudoIllustrationType.training:
      case JudoIllustrationType.competition:
      case JudoIllustrationType.tacticalIntelligence:
      case JudoIllustrationType.combination:
        return JudoColors.success;

      case JudoIllustrationType.mistakesAndSafety:
        return JudoColors.danger;

      case JudoIllustrationType.technicalAnalysis:
      case JudoIllustrationType.biomechanics:
      case JudoIllustrationType.gripFighting:
      case JudoIllustrationType.balanceAnalysis:
        return JudoColors.primary;
    }
  }
}

class _JudoIllustrationPainter extends CustomPainter {
  final JudoIllustrationType type;
  final Color color;

  const _JudoIllustrationPainter({
    required this.type,
    required this.color,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final strokeWidth =
        math.max(1.7, size.shortestSide * 0.045);

    final primaryPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final secondaryPaint = Paint()
      ..color = color.withValues(alpha: 0.42)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 0.72
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.14)
      ..style = PaintingStyle.fill;

    switch (type) {
      case JudoIllustrationType.sensiBot:
        _paintSensiBot(
          canvas,
          size,
          primaryPaint,
          secondaryPaint,
          fillPaint,
        );
        break;

      case JudoIllustrationType.quiz:
        _paintQuiz(
          canvas,
          size,
          primaryPaint,
          secondaryPaint,
          fillPaint,
        );
        break;

      case JudoIllustrationType.training:
        _paintTraining(
          canvas,
          size,
          primaryPaint,
          secondaryPaint,
        );
        break;

      case JudoIllustrationType.competition:
        _paintCompetition(
          canvas,
          size,
          primaryPaint,
          secondaryPaint,
          fillPaint,
        );
        break;

      case JudoIllustrationType.mastery:
        _paintMastery(
          canvas,
          size,
          primaryPaint,
          secondaryPaint,
          fillPaint,
        );
        break;

      case JudoIllustrationType.tacticalIntelligence:
        _paintTactical(
          canvas,
          size,
          primaryPaint,
          secondaryPaint,
        );
        break;

      case JudoIllustrationType.technicalAnalysis:
      case JudoIllustrationType.biomechanics:
        _paintBiomechanics(
          canvas,
          size,
          primaryPaint,
          secondaryPaint,
        );
        break;

      case JudoIllustrationType.gripFighting:
        _paintGrip(
          canvas,
          size,
          primaryPaint,
          secondaryPaint,
        );
        break;

      case JudoIllustrationType.balanceAnalysis:
        _paintBalance(
          canvas,
          size,
          primaryPaint,
          secondaryPaint,
        );
        break;

      case JudoIllustrationType.fightIntelligence:
      case JudoIllustrationType.videoAnalysis:
        _paintFightIntelligence(
          canvas,
          size,
          primaryPaint,
          secondaryPaint,
          fillPaint,
        );
        break;

      case JudoIllustrationType.champion:
        _paintChampion(
          canvas,
          size,
          primaryPaint,
          secondaryPaint,
          fillPaint,
        );
        break;

      case JudoIllustrationType.combination:
        _paintCombination(
          canvas,
          size,
          primaryPaint,
          secondaryPaint,
        );
        break;

      case JudoIllustrationType.mistakesAndSafety:
        _paintSafety(
          canvas,
          size,
          primaryPaint,
          secondaryPaint,
          fillPaint,
        );
        break;
    }
  }

  void _paintSensiBot(
    Canvas canvas,
    Size size,
    Paint primary,
    Paint secondary,
    Paint fill,
  ) {
    final robotRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.20,
        size.height * 0.24,
        size.width * 0.60,
        size.height * 0.50,
      ),
      Radius.circular(size.width * 0.13),
    );

    canvas.drawRRect(robotRect, fill);
    canvas.drawRRect(robotRect, primary);

    canvas.drawCircle(
      Offset(
        size.width * 0.40,
        size.height * 0.46,
      ),
      size.width * 0.045,
      primary,
    );

    canvas.drawCircle(
      Offset(
        size.width * 0.60,
        size.height * 0.46,
      ),
      size.width * 0.045,
      primary,
    );

    canvas.drawLine(
      Offset(
        size.width * 0.40,
        size.height * 0.61,
      ),
      Offset(
        size.width * 0.60,
        size.height * 0.61,
      ),
      secondary,
    );

    canvas.drawLine(
      Offset(
        size.width * 0.50,
        size.height * 0.24,
      ),
      Offset(
        size.width * 0.50,
        size.height * 0.13,
      ),
      primary,
    );

    canvas.drawCircle(
      Offset(
        size.width * 0.50,
        size.height * 0.10,
      ),
      size.width * 0.035,
      primary,
    );

    final beltPath = Path()
      ..moveTo(
        size.width * 0.26,
        size.height * 0.78,
      )
      ..lineTo(
        size.width * 0.74,
        size.height * 0.78,
      )
      ..lineTo(
        size.width * 0.67,
        size.height * 0.90,
      )
      ..lineTo(
        size.width * 0.33,
        size.height * 0.90,
      )
      ..close();

    canvas.drawPath(beltPath, secondary);
  }

  void _paintQuiz(
    Canvas canvas,
    Size size,
    Paint primary,
    Paint secondary,
    Paint fill,
  ) {
    final beltRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.12,
        size.height * 0.39,
        size.width * 0.76,
        size.height * 0.24,
      ),
      Radius.circular(size.width * 0.06),
    );

    canvas.drawRRect(beltRect, fill);
    canvas.drawRRect(beltRect, primary);

    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.43,
        size.height * 0.35,
        size.width * 0.14,
        size.height * 0.32,
      ),
      primary,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: '?',
        style: TextStyle(
          color: color,
          fontSize: size.width * 0.38,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        size.height * 0.02,
      ),
    );

    canvas.drawLine(
      Offset(
        size.width * 0.22,
        size.height * 0.74,
      ),
      Offset(
        size.width * 0.78,
        size.height * 0.74,
      ),
      secondary,
    );
  }

  void _paintTraining(
    Canvas canvas,
    Size size,
    Paint primary,
    Paint secondary,
  ) {
    _drawJudoka(
      canvas,
      center: Offset(
        size.width * 0.34,
        size.height * 0.50,
      ),
      scale: size.width * 0.52,
      paint: primary,
      leaning: -0.08,
    );

    _drawJudoka(
      canvas,
      center: Offset(
        size.width * 0.68,
        size.height * 0.50,
      ),
      scale: size.width * 0.46,
      paint: secondary,
      leaning: 0.11,
    );

    final movementPath = Path()
      ..moveTo(
        size.width * 0.18,
        size.height * 0.83,
      )
      ..quadraticBezierTo(
        size.width * 0.48,
        size.height * 0.71,
        size.width * 0.82,
        size.height * 0.83,
      );

    canvas.drawPath(movementPath, secondary);

    _drawArrowHead(
      canvas,
      Offset(
        size.width * 0.82,
        size.height * 0.83,
      ),
      direction: 0.30,
      paint: secondary,
      size: size.width * 0.07,
    );
  }

  void _paintCompetition(
    Canvas canvas,
    Size size,
    Paint primary,
    Paint secondary,
    Paint fill,
  ) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.08,
          size.height * 0.72,
          size.width * 0.84,
          size.height * 0.16,
        ),
        Radius.circular(size.width * 0.04),
      ),
      fill,
    );

    canvas.drawLine(
      Offset(
        size.width * 0.08,
        size.height * 0.80,
      ),
      Offset(
        size.width * 0.92,
        size.height * 0.80,
      ),
      primary,
    );

    _drawJudoka(
      canvas,
      center: Offset(
        size.width * 0.35,
        size.height * 0.46,
      ),
      scale: size.width * 0.47,
      paint: primary,
      leaning: 0.04,
    );

    _drawJudoka(
      canvas,
      center: Offset(
        size.width * 0.66,
        size.height * 0.46,
      ),
      scale: size.width * 0.44,
      paint: secondary,
      leaning: -0.08,
    );

    canvas.drawCircle(
      Offset(
        size.width * 0.50,
        size.height * 0.13,
      ),
      size.width * 0.09,
      primary,
    );

    canvas.drawLine(
      Offset(
        size.width * 0.50,
        size.height * 0.22,
      ),
      Offset(
        size.width * 0.50,
        size.height * 0.29,
      ),
      secondary,
    );
  }

  void _paintMastery(
    Canvas canvas,
    Size size,
    Paint primary,
    Paint secondary,
    Paint fill,
  ) {
    canvas.drawCircle(
      Offset(
        size.width * 0.50,
        size.height * 0.42,
      ),
      size.width * 0.25,
      fill,
    );

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(
          size.width * 0.50,
          size.height * 0.42,
        ),
        radius: size.width * 0.25,
      ),
      -math.pi / 2,
      math.pi * 1.55,
      false,
      primary,
    );

    final medalPath = Path()
      ..moveTo(
        size.width * 0.37,
        size.height * 0.63,
      )
      ..lineTo(
        size.width * 0.43,
        size.height * 0.90,
      )
      ..lineTo(
        size.width * 0.50,
        size.height * 0.79,
      )
      ..lineTo(
        size.width * 0.57,
        size.height * 0.90,
      )
      ..lineTo(
        size.width * 0.63,
        size.height * 0.63,
      );

    canvas.drawPath(medalPath, secondary);

    final checkPath = Path()
      ..moveTo(
        size.width * 0.39,
        size.height * 0.43,
      )
      ..lineTo(
        size.width * 0.47,
        size.height * 0.52,
      )
      ..lineTo(
        size.width * 0.64,
        size.height * 0.32,
      );

    canvas.drawPath(checkPath, primary);
  }

  void _paintTactical(
    Canvas canvas,
    Size size,
    Paint primary,
    Paint secondary,
  ) {
    _drawJudoka(
      canvas,
      center: Offset(
        size.width * 0.30,
        size.height * 0.54,
      ),
      scale: size.width * 0.42,
      paint: primary,
      leaning: 0.05,
    );

    _drawJudoka(
      canvas,
      center: Offset(
        size.width * 0.72,
        size.height * 0.54,
      ),
      scale: size.width * 0.42,
      paint: secondary,
      leaning: -0.05,
    );

    final path = Path()
      ..moveTo(
        size.width * 0.26,
        size.height * 0.20,
      )
      ..quadraticBezierTo(
        size.width * 0.50,
        size.height * 0.03,
        size.width * 0.74,
        size.height * 0.20,
      );

    canvas.drawPath(path, primary);

    _drawArrowHead(
      canvas,
      Offset(
        size.width * 0.74,
        size.height * 0.20,
      ),
      direction: 0.55,
      paint: primary,
      size: size.width * 0.07,
    );
  }

  void _paintBiomechanics(
    Canvas canvas,
    Size size,
    Paint primary,
    Paint secondary,
  ) {
    _drawJudoka(
      canvas,
      center: Offset(
        size.width * 0.48,
        size.height * 0.50,
      ),
      scale: size.width * 0.62,
      paint: primary,
      leaning: 0.14,
    );

    canvas.drawCircle(
      Offset(
        size.width * 0.49,
        size.height * 0.52,
      ),
      size.width * 0.055,
      secondary,
    );

    canvas.drawLine(
      Offset(
        size.width * 0.49,
        size.height * 0.52,
      ),
      Offset(
        size.width * 0.82,
        size.height * 0.30,
      ),
      secondary,
    );

    _drawArrowHead(
      canvas,
      Offset(
        size.width * 0.82,
        size.height * 0.30,
      ),
      direction: -0.58,
      paint: secondary,
      size: size.width * 0.07,
    );

    canvas.drawLine(
      Offset(
        size.width * 0.18,
        size.height * 0.83,
      ),
      Offset(
        size.width * 0.82,
        size.height * 0.83,
      ),
      secondary,
    );
  }

  void _paintGrip(
    Canvas canvas,
    Size size,
    Paint primary,
    Paint secondary,
  ) {
    final leftHand = Path()
      ..moveTo(
        size.width * 0.12,
        size.height * 0.60,
      )
      ..quadraticBezierTo(
        size.width * 0.30,
        size.height * 0.31,
        size.width * 0.48,
        size.height * 0.51,
      )
      ..quadraticBezierTo(
        size.width * 0.55,
        size.height * 0.59,
        size.width * 0.63,
        size.height * 0.50,
      );

    canvas.drawPath(leftHand, primary);

    final rightHand = Path()
      ..moveTo(
        size.width * 0.88,
        size.height * 0.60,
      )
      ..quadraticBezierTo(
        size.width * 0.70,
        size.height * 0.31,
        size.width * 0.52,
        size.height * 0.51,
      )
      ..quadraticBezierTo(
        size.width * 0.45,
        size.height * 0.59,
        size.width * 0.37,
        size.height * 0.50,
      );

    canvas.drawPath(rightHand, secondary);

    canvas.drawCircle(
      Offset(
        size.width * 0.50,
        size.height * 0.52,
      ),
      size.width * 0.09,
      primary,
    );

    canvas.drawLine(
      Offset(
        size.width * 0.22,
        size.height * 0.76,
      ),
      Offset(
        size.width * 0.78,
        size.height * 0.76,
      ),
      secondary,
    );
  }

  void _paintBalance(
    Canvas canvas,
    Size size,
    Paint primary,
    Paint secondary,
  ) {
    _drawJudoka(
      canvas,
      center: Offset(
        size.width * 0.50,
        size.height * 0.47,
      ),
      scale: size.width * 0.58,
      paint: primary,
      leaning: 0.13,
    );

    canvas.drawLine(
      Offset(
        size.width * 0.50,
        size.height * 0.13,
      ),
      Offset(
        size.width * 0.50,
        size.height * 0.84,
      ),
      secondary,
    );

    canvas.drawCircle(
      Offset(
        size.width * 0.54,
        size.height * 0.52,
      ),
      size.width * 0.045,
      secondary,
    );

    final basePath = Path()
      ..moveTo(
        size.width * 0.22,
        size.height * 0.86,
      )
      ..lineTo(
        size.width * 0.78,
        size.height * 0.86,
      );

    canvas.drawPath(basePath, primary);
  }

  void _paintFightIntelligence(
    Canvas canvas,
    Size size,
    Paint primary,
    Paint secondary,
    Paint fill,
  ) {
    _drawJudoka(
      canvas,
      center: Offset(
        size.width * 0.30,
        size.height * 0.52,
      ),
      scale: size.width * 0.40,
      paint: primary,
      leaning: 0.05,
    );

    _drawJudoka(
      canvas,
      center: Offset(
        size.width * 0.70,
        size.height * 0.52,
      ),
      scale: size.width * 0.40,
      paint: secondary,
      leaning: -0.05,
    );

    canvas.drawCircle(
      Offset(
        size.width * 0.50,
        size.height * 0.43,
      ),
      size.width * 0.12,
      fill,
    );

    canvas.drawCircle(
      Offset(
        size.width * 0.50,
        size.height * 0.43,
      ),
      size.width * 0.12,
      primary,
    );

    canvas.drawLine(
      Offset(
        size.width * 0.46,
        size.height * 0.43,
      ),
      Offset(
        size.width * 0.54,
        size.height * 0.43,
      ),
      primary,
    );

    canvas.drawLine(
      Offset(
        size.width * 0.50,
        size.height * 0.39,
      ),
      Offset(
        size.width * 0.50,
        size.height * 0.47,
      ),
      primary,
    );

    canvas.drawArc(
      Rect.fromLTWH(
        size.width * 0.16,
        size.height * 0.15,
        size.width * 0.68,
        size.height * 0.68,
      ),
      -0.30,
      1.70,
      false,
      secondary,
    );
  }

  void _paintChampion(
    Canvas canvas,
    Size size,
    Paint primary,
    Paint secondary,
    Paint fill,
  ) {
    _drawJudoka(
      canvas,
      center: Offset(
        size.width * 0.50,
        size.height * 0.51,
      ),
      scale: size.width * 0.58,
      paint: primary,
      leaning: 0,
    );

    final crown = Path()
      ..moveTo(
        size.width * 0.30,
        size.height * 0.19,
      )
      ..lineTo(
        size.width * 0.38,
        size.height * 0.07,
      )
      ..lineTo(
        size.width * 0.50,
        size.height * 0.18,
      )
      ..lineTo(
        size.width * 0.62,
        size.height * 0.07,
      )
      ..lineTo(
        size.width * 0.70,
        size.height * 0.19,
      )
      ..close();

    canvas.drawPath(crown, fill);
    canvas.drawPath(crown, primary);

    canvas.drawCircle(
      Offset(
        size.width * 0.76,
        size.height * 0.68,
      ),
      size.width * 0.11,
      secondary,
    );
  }

  void _paintCombination(
    Canvas canvas,
    Size size,
    Paint primary,
    Paint secondary,
  ) {
    _drawJudoka(
      canvas,
      center: Offset(
        size.width * 0.26,
        size.height * 0.52,
      ),
      scale: size.width * 0.34,
      paint: primary,
      leaning: 0.05,
    );

    _drawJudoka(
      canvas,
      center: Offset(
        size.width * 0.74,
        size.height * 0.52,
      ),
      scale: size.width * 0.34,
      paint: secondary,
      leaning: -0.12,
    );

    canvas.drawLine(
      Offset(
        size.width * 0.39,
        size.height * 0.30,
      ),
      Offset(
        size.width * 0.61,
        size.height * 0.30,
      ),
      primary,
    );

    _drawArrowHead(
      canvas,
      Offset(
        size.width * 0.61,
        size.height * 0.30,
      ),
      direction: 0,
      paint: primary,
      size: size.width * 0.065,
    );

    canvas.drawLine(
      Offset(
        size.width * 0.61,
        size.height * 0.75,
      ),
      Offset(
        size.width * 0.39,
        size.height * 0.75,
      ),
      secondary,
    );

    _drawArrowHead(
      canvas,
      Offset(
        size.width * 0.39,
        size.height * 0.75,
      ),
      direction: math.pi,
      paint: secondary,
      size: size.width * 0.065,
    );
  }

  void _paintSafety(
    Canvas canvas,
    Size size,
    Paint primary,
    Paint secondary,
    Paint fill,
  ) {
    final shield = Path()
      ..moveTo(
        size.width * 0.50,
        size.height * 0.08,
      )
      ..lineTo(
        size.width * 0.80,
        size.height * 0.20,
      )
      ..lineTo(
        size.width * 0.74,
        size.height * 0.65,
      )
      ..quadraticBezierTo(
        size.width * 0.64,
        size.height * 0.83,
        size.width * 0.50,
        size.height * 0.91,
      )
      ..quadraticBezierTo(
        size.width * 0.36,
        size.height * 0.83,
        size.width * 0.26,
        size.height * 0.65,
      )
      ..lineTo(
        size.width * 0.20,
        size.height * 0.20,
      )
      ..close();

    canvas.drawPath(shield, fill);
    canvas.drawPath(shield, primary);

    canvas.drawLine(
      Offset(
        size.width * 0.50,
        size.height * 0.30,
      ),
      Offset(
        size.width * 0.50,
        size.height * 0.58,
      ),
      secondary,
    );

    canvas.drawCircle(
      Offset(
        size.width * 0.50,
        size.height * 0.70,
      ),
      size.width * 0.025,
      secondary,
    );
  }

  void _drawJudoka(
    Canvas canvas, {
    required Offset center,
    required double scale,
    required Paint paint,
    required double leaning,
  }) {
    final headCenter = Offset(
      center.dx + scale * leaning,
      center.dy - scale * 0.34,
    );

    canvas.drawCircle(
      headCenter,
      scale * 0.075,
      paint,
    );

    final shoulder = Offset(
      center.dx + scale * leaning * 0.60,
      center.dy - scale * 0.20,
    );

    final hip = Offset(
      center.dx,
      center.dy + scale * 0.05,
    );

    canvas.drawLine(
      shoulder,
      hip,
      paint,
    );

    canvas.drawLine(
      shoulder,
      Offset(
        center.dx - scale * 0.20,
        center.dy - scale * 0.02,
      ),
      paint,
    );

    canvas.drawLine(
      shoulder,
      Offset(
        center.dx + scale * 0.21,
        center.dy - scale * 0.02,
      ),
      paint,
    );

    canvas.drawLine(
      hip,
      Offset(
        center.dx - scale * 0.15,
        center.dy + scale * 0.35,
      ),
      paint,
    );

    canvas.drawLine(
      hip,
      Offset(
        center.dx + scale * 0.18,
        center.dy + scale * 0.34,
      ),
      paint,
    );

    canvas.drawLine(
      Offset(
        center.dx - scale * 0.12,
        center.dy - scale * 0.12,
      ),
      Offset(
        center.dx + scale * 0.13,
        center.dy - scale * 0.12,
      ),
      paint,
    );
  }

  void _drawArrowHead(
    Canvas canvas,
    Offset tip, {
    required double direction,
    required Paint paint,
    required double size,
  }) {
    final left = Offset(
      tip.dx -
          size *
              math.cos(
                direction - math.pi / 5,
              ),
      tip.dy -
          size *
              math.sin(
                direction - math.pi / 5,
              ),
    );

    final right = Offset(
      tip.dx -
          size *
              math.cos(
                direction + math.pi / 5,
              ),
      tip.dy -
          size *
              math.sin(
                direction + math.pi / 5,
              ),
    );

    canvas.drawLine(tip, left, paint);
    canvas.drawLine(tip, right, paint);
  }

  @override
  bool shouldRepaint(
    covariant _JudoIllustrationPainter oldDelegate,
  ) {
    return oldDelegate.type != type ||
        oldDelegate.color != color;
  }
}