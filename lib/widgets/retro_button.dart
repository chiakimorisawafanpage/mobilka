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
    final isLink = variant == RetroButtonVariant.link;
    final isDanger = variant == RetroButtonVariant.danger;

    if (isLink) {
      return TextButton(
        onPressed: disabled ? null : onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
              vertical: RetroSpacing.xs, horizontal: 0),
          foregroundColor: RetroTheme.link,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontFamily: 'monospace',
            decoration: TextDecoration.underline,
          ),
        ),
        child: Text('>> $title <<'),
      );
    }

    return Opacity(
      opacity: disabled ? 0.45 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: disabled ? null : onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(
                vertical: RetroSpacing.sm, horizontal: RetroSpacing.md),
            decoration: BoxDecoration(
              color: isDanger
                  ? const Color(0xFF330000)
                  : RetroTheme.win98Gray,
              border: Border(
                top: BorderSide(
                  color: isDanger
                      ? const Color(0xFFFF6666)
                      : RetroTheme.win98Light,
                  width: 2,
                ),
                left: BorderSide(
                  color: isDanger
                      ? const Color(0xFFFF6666)
                      : RetroTheme.win98Light,
                  width: 2,
                ),
                right: BorderSide(
                  color: isDanger
                      ? const Color(0xFF660000)
                      : RetroTheme.win98Darkest,
                  width: 2,
                ),
                bottom: BorderSide(
                  color: isDanger
                      ? const Color(0xFF660000)
                      : RetroTheme.win98Darkest,
                  width: 2,
                ),
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: 'monospace',
                fontSize: 12,
                color: isDanger ? RetroTheme.danger : const Color(0xFF000000),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
