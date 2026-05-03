import 'package:flutter/material.dart';

import '../theme.dart';

class RetroPanel extends StatelessWidget {
  const RetroPanel({super.key, this.title, required this.child});

  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: RetroTheme.panel.withValues(alpha: 0.9),
        border: const Border(
          top: BorderSide(color: RetroTheme.stoneGray, width: 2),
          left: BorderSide(color: RetroTheme.stoneGray, width: 2),
          right: BorderSide(color: Color(0xFF1A1A1A), width: 2),
          bottom: BorderSide(color: Color(0xFF1A1A1A), width: 2),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33CC0000),
            offset: Offset(0, 0),
            blurRadius: 6,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Color(0xFF000000),
            offset: Offset(3, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: RetroSpacing.sm, vertical: RetroSpacing.xs),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF1A0000),
                    Color(0xFF330000),
                    Color(0xFF1A0000),
                  ],
                ),
                border: Border(
                  bottom:
                      BorderSide(color: RetroTheme.darkRed, width: 1),
                ),
              ),
              child: Row(
                children: [
                  const Text('\u2620 ',
                      style: TextStyle(
                          fontSize: 12, color: RetroTheme.bloodRed)),
                  Expanded(
                    child: Text(
                      title!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace',
                        letterSpacing: 1.2,
                        color: RetroTheme.bloodRed,
                        fontSize: 12,
                        shadows: [
                          Shadow(
                              offset: Offset(0, 0),
                              color: Color(0xFFFF0000),
                              blurRadius: 4),
                        ],
                      ),
                    ),
                  ),
                  const Text(' \u2620',
                      style: TextStyle(
                          fontSize: 12, color: RetroTheme.bloodRed)),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(RetroSpacing.sm),
            child: child,
          ),
        ],
      ),
    );
  }
}
