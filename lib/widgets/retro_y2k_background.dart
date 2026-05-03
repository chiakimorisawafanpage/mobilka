import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';

/// Фон в духе «личных страниц 2000-х»: полосы, звёзды, «кислотные» блоки.
class RetroY2KBackground extends StatelessWidget {
  const RetroY2KBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const RepaintBoundary(
      child: CustomPaint(
        painter: _Y2KPainter(),
        child: SizedBox.expand(),
      ),
    );
  }
}

class _Y2KPainter extends CustomPainter {
  const _Y2KPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final bg = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFB8A9FF),
          Color(0xFFFFB8E6),
          Color(0xFFB8FFD0),
          Color(0xFFFFE8A8),
        ],
        stops: [0.0, 0.35, 0.65, 1.0],
      ).createShader(rect);
    canvas.drawRect(rect, bg);

    final stripe = Paint()..color = const Color(0x33FFFFFF);
    for (double y = -size.height; y < size.height * 2; y += 18) {
      final path = Path()
        ..moveTo(0, y)
        ..lineTo(size.width, y + 40)
        ..lineTo(size.width, y + 48)
        ..lineTo(0, y + 8)
        ..close();
      canvas.drawPath(path, stripe);
    }

    final rnd = math.Random(42);
    final star = Paint()..color = const Color(0xAAFFFFFF);
    for (var i = 0; i < 120; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = rnd.nextDouble() * size.height;
      final r = rnd.nextDouble() * 1.6 + 0.4;
      canvas.drawCircle(Offset(x, y), r, star);
    }

    final blockPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = RetroTheme.border.withValues(alpha: 0.35);

    for (var i = 0; i < 8; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = rnd.nextDouble() * size.height;
      final w = rnd.nextDouble() * 70 + 40;
      final h = rnd.nextDouble() * 50 + 24;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(x, y, w, h), const Radius.circular(0)),
        blockPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
