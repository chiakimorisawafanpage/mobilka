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
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFF2F6FF)],
        ),
        border: Border.all(color: RetroTheme.border, width: 2),
        boxShadow: const [
          BoxShadow(
              color: Color(0x66000000), offset: Offset(2, 2), blurRadius: 0),
        ],
      ),
      padding: const EdgeInsets.all(RetroSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: RetroTheme.text,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: RetroSpacing.sm),
          ],
          child,
        ],
      ),
    );
  }
}
