import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../logic/constants.dart';

class BubblePainter extends CustomPainter {
  final double animValue;
  BubblePainter(this.animValue);

  @override
  void paint(Canvas canvas, Size size) {
    final bubbles = [
      Bubble(0.12, 0.08, 60, BC.primaryFrost.withOpacity(0.55)),
      Bubble(0.85, 0.14, 90, BC.primaryPale.withOpacity(0.30)),
      Bubble(0.05, 0.55, 45, BC.primaryFrost.withOpacity(0.70)),
      Bubble(0.92, 0.62, 70, BC.primaryPale.withOpacity(0.35)),
      Bubble(0.45, 0.88, 55, BC.primaryFrost.withOpacity(0.40)),
      Bubble(0.70, 0.35, 40, BC.lavender.withOpacity(0.08)),
      Bubble(0.25, 0.30, 35, BC.mint.withOpacity(0.08)),
    ];
    for (final b in bubbles) {
      final dx = math.sin(animValue * 2 * math.pi + b.phase) * 8;
      final dy = math.cos(animValue * 2 * math.pi + b.phase) * 6;
      canvas.drawCircle(
        Offset(size.width * b.x + dx, size.height * b.y + dy),
        b.r,
        Paint()
          ..color = b.color
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(BubblePainter old) => old.animValue != animValue;
}

class Bubble {
  final double x, y, r, phase;
  final Color color;
  Bubble(this.x, this.y, this.r, this.color) : phase = x * 6.28;
}
