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
        color: RetroTheme.panel.withValues(alpha: 0.85),
        border: const Border(
          top: BorderSide(color: RetroTheme.accentBlue, width: 2),
          left: BorderSide(color: RetroTheme.accentBlue, width: 2),
          right: BorderSide(color: Color(0xFF000066), width: 2),
          bottom: BorderSide(color: Color(0xFF000066), width: 2),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x5500FFFF),
            offset: Offset(0, 0),
            blurRadius: 8,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Color(0xFF000000),
            offset: Offset(3, 3),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: RetroSpacing.sm, vertical: RetroSpacing.xs),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF000080), Color(0xFF6600CC)],
                ),
                border: Border(
                  bottom: BorderSide(color: RetroTheme.accentCyan, width: 1),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    '\u2605 ',
                    style: TextStyle(
                      color: RetroTheme.accentYellow,
                      fontSize: 12,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      title!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace',
                        color: RetroTheme.accentYellow,
                        fontSize: 13,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            color: Color(0xFF000000),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Text(
                    ' \u2605',
                    style: TextStyle(
                      color: RetroTheme.accentYellow,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.all(RetroSpacing.md),
            child: child,
          ),
        ],
      ),
    );
  }
}
