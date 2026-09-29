import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/judo_design_tokens.dart';

/// ----------------------------------------------------------------
/// Judo Mind Super App
/// Uchi Mata Three-Layer Painter
/// Version: 1.0.0
/// ----------------------------------------------------------------
///
/// Tori:
/// The judoka executing Uchi Mata.
///
/// Uke:
/// The judoka receiving the technique.
///
/// Blue:
/// Footwork, entry and attacking-leg path.
///
/// Gold:
/// Sleeve, lapel and upper-body control.
///
/// Green:
/// Illustrative direction and balance concepts.
class UchiMataThreeLayerPainter extends CustomPainter {
  final double progress;

  final bool showMovement;
  final bool showControl;
  final bool showBiomechanics;
  final String? phaseLabel;
  final Color? phaseColor;

  const UchiMataThreeLayerPainter({
    required this.progress,
    required this.showMovement,
    required this.showControl,
    required this.showBiomechanics,
    this.phaseLabel,
    this.phaseColor,
  });

  double get _throwProgress {
    return Curves.easeInOut.transform(progress);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final groundY = size.height * 0.82;

    _drawGround(canvas, size, groundY);

    if (showMovement) {
      _drawMovementPath(canvas, size, groundY);
    }

    _drawTori(canvas, size, groundY);

    _drawUke(canvas, size, groundY);

    if (showControl) {
      _drawGripControl(canvas, size, groundY);
    }

    if (showBiomechanics) {
      _drawBiomechanics(canvas, size, groundY);
    }

    final visiblePhaseLabel = phaseLabel?.trim() ?? '';
    if (visiblePhaseLabel.isNotEmpty) {
      _drawPhaseIndicator(
        canvas,
        size,
        visiblePhaseLabel,
        phaseColor ?? JudoColors.primary,
      );
    }
  }

  void _drawGround(Canvas canvas, Size size, double groundY) {
    final groundPaint = Paint()
      ..color = JudoColors.white.withValues(alpha: 0.10)
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(size.width * 0.08, groundY),
      Offset(size.width * 0.92, groundY),
      groundPaint,
    );
  }

  void _drawTori(Canvas canvas, Size size, double groundY) {
    final movement = _throwProgress;

    final startX = size.width * 0.30;
    final endX = size.width * 0.48;

    final toriX = _lerp(startX, endX, movement);

    final hipY = groundY - size.height * 0.25;

    final rotation = -0.10 - (movement * 0.34);

    canvas.save();

    canvas.translate(toriX, hipY);

    canvas.rotate(rotation);

    final bodyPaint = Paint()
      ..color = JudoColors.primary
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final jointPaint = Paint()
      ..color = JudoColors.primary
      ..style = PaintingStyle.fill;

    final head = Offset(0, -size.height * 0.22);

    final shoulder = Offset(0, -size.height * 0.15);

    const hip = Offset.zero;

    final supportFoot = Offset(-size.width * 0.05, size.height * 0.25);

    final attackingLegLift = math.sin(movement * math.pi) * size.height * 0.12;

    final attackingFoot = Offset(
      size.width * (0.12 + movement * 0.08),
      size.height * 0.13 - attackingLegLift,
    );

    final leftHand = Offset(-size.width * 0.15, -size.height * 0.12);

    final rightHand = Offset(size.width * 0.15, -size.height * 0.14);

    canvas.drawCircle(head, size.width * 0.043, bodyPaint);

    canvas.drawLine(shoulder, hip, bodyPaint);

    canvas.drawLine(shoulder, leftHand, bodyPaint);

    canvas.drawLine(shoulder, rightHand, bodyPaint);

    canvas.drawLine(hip, supportFoot, bodyPaint);

    canvas.drawLine(hip, attackingFoot, bodyPaint);

    canvas.drawCircle(hip, 6, jointPaint);

    canvas.drawCircle(shoulder, 5, jointPaint);

    canvas.restore();
  }

  void _drawUke(Canvas canvas, Size size, double groundY) {
    final movement = _throwProgress;

    final ukeX = _lerp(size.width * 0.64, size.width * 0.56, movement);

    final lift = math.sin(movement * math.pi) * size.height * 0.14;

    final hipY = groundY - size.height * 0.25 - lift;

    final rotation = movement * 1.12;

    canvas.save();

    canvas.translate(ukeX, hipY);

    canvas.rotate(rotation);

    final bodyPaint = Paint()
      ..color = JudoColors.white.withValues(alpha: 0.65)
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final head = Offset(0, -size.height * 0.22);

    final shoulder = Offset(0, -size.height * 0.15);

    const hip = Offset.zero;

    final leftHand = Offset(-size.width * 0.14, -size.height * 0.10);

    final rightHand = Offset(size.width * 0.14, -size.height * 0.10);

    final leftFoot = Offset(-size.width * 0.08, size.height * 0.24);

    final rightFoot = Offset(size.width * 0.09, size.height * 0.24);

    canvas.drawCircle(head, size.width * 0.043, bodyPaint);

    canvas.drawLine(shoulder, hip, bodyPaint);

    canvas.drawLine(shoulder, leftHand, bodyPaint);

    canvas.drawLine(shoulder, rightHand, bodyPaint);

    canvas.drawLine(hip, leftFoot, bodyPaint);

    canvas.drawLine(hip, rightFoot, bodyPaint);

    canvas.restore();
  }

  void _drawMovementPath(Canvas canvas, Size size, double groundY) {
    final pathPaint = Paint()
      ..color = JudoColors.primary.withValues(alpha: 0.85)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width * 0.20, groundY - size.height * 0.02)
      ..quadraticBezierTo(
        size.width * 0.36,
        groundY - size.height * 0.08,
        size.width * 0.48,
        groundY - size.height * 0.02,
      )
      ..quadraticBezierTo(
        size.width * 0.58,
        groundY + size.height * 0.03,
        size.width * 0.62,
        groundY - size.height * 0.12,
      );

    canvas.drawPath(path, pathPaint);

    final marker = Offset(
      _lerp(size.width * 0.20, size.width * 0.62, _throwProgress),
      groundY -
          size.height * (0.02 + math.sin(_throwProgress * math.pi) * 0.08),
    );

    canvas.drawCircle(marker, 7, Paint()..color = JudoColors.primary);
  }

  void _drawGripControl(Canvas canvas, Size size, double groundY) {
    final movement = _throwProgress;

    final toriCenter = Offset(
      _lerp(size.width * 0.30, size.width * 0.48, movement),
      groundY - size.height * 0.40,
    );

    final ukeCenter = Offset(
      _lerp(size.width * 0.64, size.width * 0.56, movement),
      groundY - size.height * (0.40 + math.sin(movement * math.pi) * 0.14),
    );

    final gripPaint = Paint()
      ..color = JudoColors.gold
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      toriCenter.translate(-size.width * 0.08, 0),
      ukeCenter.translate(-size.width * 0.10, size.height * 0.02),
      gripPaint,
    );

    canvas.drawLine(
      toriCenter.translate(size.width * 0.08, -size.height * 0.02),
      ukeCenter.translate(size.width * 0.08, -size.height * 0.03),
      gripPaint,
    );

    canvas.drawCircle(
      ukeCenter.translate(-size.width * 0.10, size.height * 0.02),
      6,
      Paint()..color = JudoColors.gold,
    );

    canvas.drawCircle(
      ukeCenter.translate(size.width * 0.08, -size.height * 0.03),
      6,
      Paint()..color = JudoColors.gold,
    );
  }

  void _drawBiomechanics(Canvas canvas, Size size, double groundY) {
    final movement = _throwProgress;

    final centerOfGravity = Offset(
      _lerp(size.width * 0.62, size.width * 0.55, movement),
      groundY - size.height * (0.24 + math.sin(movement * math.pi) * 0.18),
    );

    final forcePaint = Paint()
      ..color = JudoColors.success
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(centerOfGravity, 15, forcePaint);

    canvas.drawCircle(centerOfGravity, 5, Paint()..color = JudoColors.success);

    final forceEnd = Offset(
      centerOfGravity.dx + size.width * 0.18,
      centerOfGravity.dy - size.height * 0.22,
    );

    _drawArrow(canvas, centerOfGravity, forceEnd, forcePaint);

    final supportPoint = Offset(size.width * 0.44, groundY);

    final balancePaint = Paint()
      ..color = JudoColors.success.withValues(alpha: 0.45)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(centerOfGravity, supportPoint, balancePaint);

    canvas.drawCircle(supportPoint, 8, balancePaint);
  }

  void _drawArrow(Canvas canvas, Offset start, Offset end, Paint paint) {
    canvas.drawLine(start, end, paint);

    final angle = math.atan2(end.dy - start.dy, end.dx - start.dx);

    const arrowSize = 12.0;

    final first = Offset(
      end.dx - arrowSize * math.cos(angle - math.pi / 6),
      end.dy - arrowSize * math.sin(angle - math.pi / 6),
    );

    final second = Offset(
      end.dx - arrowSize * math.cos(angle + math.pi / 6),
      end.dy - arrowSize * math.sin(angle + math.pi / 6),
    );

    canvas.drawLine(end, first, paint);

    canvas.drawLine(end, second, paint);
  }

  void _drawPhaseIndicator(
    Canvas canvas,
    Size size,
    String label,
    Color color,
  ) {
    final painter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.4,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final background = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        JudoSpacing.md,
        JudoSpacing.md,
        painter.width + JudoSpacing.lg,
        painter.height + JudoSpacing.sm,
      ),
      const Radius.circular(JudoRadius.sm),
    );

    canvas.drawRRect(
      background,
      Paint()..color = color.withValues(alpha: 0.14),
    );

    painter.paint(canvas, const Offset(JudoSpacing.lg, JudoSpacing.lg));
  }

  double _lerp(double start, double end, double amount) {
    return start + (end - start) * amount;
  }

  @override
  bool shouldRepaint(covariant UchiMataThreeLayerPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.showMovement != showMovement ||
        oldDelegate.showControl != showControl ||
        oldDelegate.showBiomechanics != showBiomechanics ||
        oldDelegate.phaseLabel != phaseLabel ||
        oldDelegate.phaseColor != phaseColor;
  }
}
