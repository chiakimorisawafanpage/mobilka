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
            title,
            style: TextStyle(
              color: disabled ? RetroTheme.muted : RetroTheme.link,
              fontWeight: FontWeight.w600,
              fontFamily: 'monospace',
              fontSize: 12,
              decoration: TextDecoration.underline,
              decorationColor: disabled ? RetroTheme.muted : RetroTheme.link,
            ),
          ),
        ),
      );
    }

    final isDanger = variant == RetroButtonVariant.danger;
    final bgColor = isDanger
        ? const Color(0xFFE8D0D0)
        : RetroTheme.win98Gray;
    final lightBorder = isDanger
        ? const Color(0xFFF0E0E0)
        : RetroTheme.win98Light;
    final darkBorder = isDanger
        ? const Color(0xFFAA6666)
        : RetroTheme.win98Dark;
    final textColor = isDanger
        ? RetroTheme.danger
        : RetroTheme.text;

    return GestureDetector(
      onTap: disabled ? null : onPressed,
      child: Opacity(
        opacity: disabled ? 0.45 : 1.0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(2),
            border: Border(
              top: BorderSide(color: lightBorder, width: 1),
              left: BorderSide(color: lightBorder, width: 1),
              right: BorderSide(color: darkBorder, width: 1),
              bottom: BorderSide(color: darkBorder, width: 1),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
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
