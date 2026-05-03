import 'package:flutter/material.dart';

import '../theme.dart';

class ProductThumb extends StatelessWidget {
  const ProductThumb({
    super.key,
    required this.label,
    this.gifUrl,
    this.height = 90,
  });

  final String label;
  final String? gifUrl;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F0),
        border: Border(
          top: BorderSide(color: RetroTheme.win98Dark, width: 1),
          left: BorderSide(color: RetroTheme.win98Dark, width: 1),
          right: BorderSide(color: RetroTheme.win98Light, width: 1),
          bottom: BorderSide(color: RetroTheme.win98Light, width: 1),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (gifUrl != null)
            Image.network(
              gifUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _fallback(),
            )
          else
            _fallback(),
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: RetroTheme.win98Gray.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: RetroTheme.border, width: 0.5),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: RetroTheme.muted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallback() {
    return Center(
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          fontFamily: 'monospace',
          color: RetroTheme.muted,
        ),
      ),
    );
  }
}
