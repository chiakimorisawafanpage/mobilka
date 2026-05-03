import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';

class RetroY2KBackground extends StatefulWidget {
  const RetroY2KBackground({super.key});

  @override
  State<RetroY2KBackground> createState() => _RetroY2KBackgroundState();
}

class _RetroY2KBackgroundState extends State<RetroY2KBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          return CustomPaint(
            painter: _SpacePainter(twinkle: _ctrl.value),
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }
}

class _SpacePainter extends CustomPainter {
  const _SpacePainter({required this.twinkle});
  final double twinkle;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final bg = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF000011),
          Color(0xFF000033),
          Color(0xFF0D0030),
          Color(0xFF000022),
        ],
        stops: [0.0, 0.3, 0.7, 1.0],
      ).createShader(rect);
    canvas.drawRect(rect, bg);

    final rnd = math.Random(42);

    for (var i = 0; i < 200; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = rnd.nextDouble() * size.height;
      final baseR = rnd.nextDouble() * 1.2 + 0.3;
      final phase = rnd.nextDouble();
      final flicker =
          0.4 + 0.6 * ((math.sin((twinkle + phase) * math.pi * 2) + 1) / 2);
      final r = baseR * flicker;

      final colors = [
        const Color(0xFFFFFFFF),
        const Color(0xFFCCCCFF),
        const Color(0xFFFFFFCC),
        const Color(0xFFCCFFFF),
      ];
      final c = colors[i % colors.length];

      canvas.drawCircle(
        Offset(x, y),
        r,
        Paint()..color = c.withValues(alpha: 0.5 + 0.5 * flicker),
      );
    }

    final nebula = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.5),
        radius: 0.8,
        colors: [
          const Color(0xFF6600CC).withValues(alpha: 0.12),
          const Color(0xFFFF00FF).withValues(alpha: 0.05),
          Colors.transparent,
        ],
      ).createShader(rect);
    canvas.drawRect(rect, nebula);

    final nebula2 = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.6, 0.7),
        radius: 0.6,
        colors: [
          const Color(0xFF0066FF).withValues(alpha: 0.08),
          const Color(0xFF00FFFF).withValues(alpha: 0.04),
          Colors.transparent,
        ],
      ).createShader(rect);
    canvas.drawRect(rect, nebula2);

    final scanline = Paint()
      ..color = RetroTheme.border.withValues(alpha: 0.06);
    for (double y = 0; y < size.height; y += 3) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), scanline);
    }
  }

  @override
  bool shouldRepaint(covariant _SpacePainter oldDelegate) =>
      oldDelegate.twinkle != twinkle;
}
