import 'package:flutter/material.dart';

class BlinkText extends StatefulWidget {
  const BlinkText({super.key, required this.text, required this.style});

  final String text;
  final TextStyle style;

  @override
  State<BlinkText> createState() => _BlinkTextState();
}

class _BlinkTextState extends State<BlinkText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
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
        return Opacity(
          opacity: _ctrl.value < 0.5 ? 0.0 : 1.0,
          child: Text(widget.text, style: widget.style),
        );
      },
    );
  }
}
