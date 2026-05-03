import 'package:flutter/material.dart';

import '../theme.dart';

class RainbowDivider extends StatelessWidget {
  const RainbowDivider({super.key, this.height = 4});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF330000),
            RetroTheme.bloodRed,
            Color(0xFF660000),
            RetroTheme.bloodRed,
            Color(0xFF330000),
          ],
        ),
      ),
    );
  }
}
