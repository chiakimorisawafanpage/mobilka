import 'package:flutter/material.dart';

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
            Color(0xFFFF0000),
            Color(0xFFFF8800),
            Color(0xFFFFFF00),
            Color(0xFF00FF00),
            Color(0xFF00FFFF),
            Color(0xFF0000FF),
            Color(0xFFFF00FF),
          ],
        ),
      ),
    );
  }
}
