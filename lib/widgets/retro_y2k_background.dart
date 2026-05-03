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
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        return CustomPaint(
          painter: _GothicBackgroundPainter(_ctrl.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _GothicBackgroundPainter extends CustomPainter {
  _GothicBackgroundPainter(this.phase);
  final double phase;

  static final math.Random _rng = math.Random(666);
  static List<_Ember>? _embers;

  @override
  void paint(Canvas canvas, Size size) {
    // Pure black background
    canvas.drawRect(
        Offset.zero & size, Paint()..color = RetroTheme.bg);

    // Subtle dark red fog at bottom
    final fogPaint = Paint()
      // ignore: prefer_const_constructors
      ..shader = RadialGradient(
        center: const Alignment(0.0, 1.2),
        radius: 0.8,
        colors: const [
          Color(0xFF1A0000),
          Color(0xFF0A0000),
          RetroTheme.bg,
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, fogPaint);

    // Dark vignette corners
    final vignettePaint = Paint()
      // ignore: prefer_const_constructors
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1.0,
        colors: const [
          Colors.transparent,
          Color(0x44000000),
          Color(0xCC000000),
        ],
        stops: const [0.3, 0.7, 1.0],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, vignettePaint);

    // Spiderweb pattern in top corners
    _drawSpiderweb(canvas, const Offset(0, 0), size.width * 0.18);
    _drawSpiderweb(canvas, Offset(size.width, 0), size.width * 0.18);

    // Floating embers / dust particles
    _embers ??= List.generate(80, (_) => _Ember(_rng));
    final emberPaint = Paint();
    for (final e in _embers!) {
      final flicker =
          (math.sin((phase * math.pi * 2) + e.phaseOffset) + 1.0) / 2.0;
      final alpha = (e.baseAlpha * flicker).clamp(0.0, 1.0);
      if (alpha < 0.05) continue;

      final x = (e.x * size.width) % size.width;
      final yDrift = (e.y + phase * e.speed * 0.3) % 1.0;
      final y = yDrift * size.height;

      emberPaint.color = e.isRed
          ? Color.fromRGBO(204, 0, 0, alpha * 0.7)
          : Color.fromRGBO(255, 100, 0, alpha * 0.5);
      canvas.drawCircle(Offset(x, y), e.radius, emberPaint);
    }
  }

  void _drawSpiderweb(Canvas canvas, Offset origin, double radius) {
    final paint = Paint()
      ..color = const Color(0x18FFFFFF)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const spokes = 8;
    final spokeAngles = <double>[];
    for (var i = 0; i < spokes; i++) {
      final angle = (math.pi / 2) * (i / (spokes - 1));
      final adjustedAngle =
          origin.dx == 0 ? angle : math.pi - angle;
      spokeAngles.add(adjustedAngle);
      final end = Offset(
        origin.dx + math.cos(adjustedAngle) * radius,
        origin.dy + math.sin(adjustedAngle) * radius,
      );
      canvas.drawLine(origin, end, paint);
    }

    const rings = 5;
    for (var r = 1; r <= rings; r++) {
      final ringRadius = radius * r / rings;
      final path = Path();
      for (var i = 0; i < spokeAngles.length; i++) {
        final pt = Offset(
          origin.dx + math.cos(spokeAngles[i]) * ringRadius,
          origin.dy + math.sin(spokeAngles[i]) * ringRadius,
        );
        if (i == 0) {
          path.moveTo(pt.dx, pt.dy);
        } else {
          path.lineTo(pt.dx, pt.dy);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_GothicBackgroundPainter old) => old.phase != phase;
}

class _Ember {
  _Ember(math.Random rng)
      : x = rng.nextDouble(),
        y = rng.nextDouble(),
        radius = 0.5 + rng.nextDouble() * 1.5,
        baseAlpha = 0.3 + rng.nextDouble() * 0.7,
        phaseOffset = rng.nextDouble() * math.pi * 2,
        speed = 0.2 + rng.nextDouble() * 0.8,
        isRed = rng.nextBool();

  final double x;
  final double y;
  final double radius;
  final double baseAlpha;
  final double phaseOffset;
  final double speed;
  final bool isRed;
}
