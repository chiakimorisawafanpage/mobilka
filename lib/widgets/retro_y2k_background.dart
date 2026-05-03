import 'package:flutter/material.dart';

import '../theme.dart';

class RetroY2KBackground extends StatelessWidget {
  const RetroY2KBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFD6E6F5),
            RetroTheme.bg,
            Color(0xFFE8E4D4),
          ],
          stops: [0.0, 0.4, 1.0],
        ),
      ),
    );
  }
}
