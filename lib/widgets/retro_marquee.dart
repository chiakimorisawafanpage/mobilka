import 'package:flutter/material.dart';

import '../theme.dart';

class RetroMarquee extends StatefulWidget {
  const RetroMarquee({super.key, required this.text});

  final String text;

  @override
  State<RetroMarquee> createState() => _RetroMarqueeState();
}

class _RetroMarqueeState extends State<RetroMarquee>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 22))
      ..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontWeight: FontWeight.w900,
      fontFamily: 'monospace',
      fontSize: 13,
      letterSpacing: 1.1,
      color: RetroTheme.accentYellow,
      shadows: [
        Shadow(offset: Offset(1, 1), color: Color(0xFFFF0000), blurRadius: 0),
        Shadow(offset: Offset(-1, -1), color: Color(0xFF00FFFF), blurRadius: 0),
      ],
    );

    final segment = '${widget.text}   \u2605   ';
    final tp = TextPainter(
      text: TextSpan(text: segment, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    final segW = tp.width;

    return ClipRect(
      child: Container(
        height: 30,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF000066),
              Color(0xFF330066),
              Color(0xFF000066),
            ],
          ),
          border: Border.symmetric(
            horizontal: BorderSide(color: RetroTheme.accentCyan, width: 1),
          ),
        ),
        alignment: Alignment.centerLeft,
        child: AnimatedBuilder(
          animation: _c,
          builder: (context, _) {
            final dx = -(_c.value * segW);
            return Transform.translate(
              offset: Offset(dx, 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(6, (_) => Text(segment, style: style)),
              ),
            );
          },
        ),
      ),
    );
  }
}
