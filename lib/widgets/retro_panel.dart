import 'package:flutter/material.dart';

import '../theme.dart';

class RetroPanel extends StatelessWidget {
  const RetroPanel({super.key, this.title, required this.child});

  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: RetroTheme.panel,
        border: Border(
          top: BorderSide(color: RetroTheme.win98Light, width: 1),
          left: BorderSide(color: RetroTheme.win98Light, width: 1),
          right: BorderSide(color: RetroTheme.win98Dark, width: 1),
          bottom: BorderSide(color: RetroTheme.win98Dark, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x18000000),
            offset: Offset(1, 2),
            blurRadius: 4,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: RetroSpacing.sm, vertical: 5),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [RetroTheme.titleBar, RetroTheme.titleBarEnd],
                ),
              ),
              child: Text(
                title!,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'monospace',
                  letterSpacing: 0.3,
                  color: Colors.white,
                  fontSize: 12,
                  shadows: [
                    Shadow(
                        offset: Offset(1, 1),
                        color: Color(0x44000000),
                        blurRadius: 0),
                  ],
                ),
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
