import 'package:flutter/material.dart';

import '../theme.dart';

enum RetroButtonVariant { primary, danger, link }

class RetroButton extends StatelessWidget {
  const RetroButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.disabled = false,
    this.variant = RetroButtonVariant.primary,
  });

  final String title;
  final VoidCallback onPressed;
  final bool disabled;
  final RetroButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    if (variant == RetroButtonVariant.link) {
      return GestureDetector(
        onTap: disabled ? null : onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            '\u00BB $title',
            style: TextStyle(
              color: disabled
                  ? RetroTheme.muted
                  : RetroTheme.bloodRed,
              fontWeight: FontWeight.w800,
              fontFamily: 'monospace',
              fontSize: 12,
              decoration: TextDecoration.underline,
              decorationColor: RetroTheme.bloodRed,
            ),
          ),
        ),
      );
    }

    final isDanger = variant == RetroButtonVariant.danger;
    final bgColor = isDanger
        ? RetroTheme.darkRed
        : RetroTheme.win98Gray;
    final lightBorder = isDanger
        ? RetroTheme.bloodRed
        : RetroTheme.win98Light;
    final darkBorder = isDanger
        ? const Color(0xFF330000)
        : RetroTheme.win98Darkest;
    final textColor = isDanger
        ? RetroTheme.boneWhite
        : const Color(0xFF000000);

    return GestureDetector(
      onTap: disabled ? null : onPressed,
      child: Opacity(
        opacity: disabled ? 0.45 : 1.0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border(
              top: BorderSide(color: lightBorder, width: 2),
              left: BorderSide(color: lightBorder, width: 2),
              right: BorderSide(color: darkBorder, width: 2),
              bottom: BorderSide(color: darkBorder, width: 2),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontFamily: 'monospace',
              fontSize: 12,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
