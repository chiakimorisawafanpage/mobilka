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
            decoration: TextDecoration.underline,
          ),
        ),
        child: Text(title),
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
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDanger
                    ? const [Color(0xFFFFE0E0), Color(0xFFFFC4C4)]
                    : const [RetroTheme.accentBg, RetroTheme.accentBlue],
              ),
              border: Border.all(color: RetroTheme.border, width: 2),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x66000000),
                    offset: Offset(2, 2),
                    blurRadius: 0),
              ],
            ),
            child: Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, color: RetroTheme.text),
            ),
          ),
        ),
      ),
    );
  }
}
