import 'package:flutter/material.dart';

import '../theme.dart';

class RainbowDivider extends StatelessWidget {
  const RainbowDivider({super.key, this.height = 2});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            RetroTheme.accentBlue,
            RetroTheme.accentCyan,
            RetroTheme.accentBlue,
          ],
        ),
      ),
    );
  }
}
