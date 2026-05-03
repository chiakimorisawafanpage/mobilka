import 'package:flutter/material.dart';

import '../theme.dart';

class ProductThumb extends StatelessWidget {
  const ProductThumb({
    super.key,
    required this.label,
    this.gifUrl,
    this.height = 92,
  });

  final String label;
  final String? gifUrl;
  final double height;

  @override
  Widget build(BuildContext context) {
    final url = gifUrl?.trim();
    final hasUrl = url != null && url.isNotEmpty;

    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF000000),
        border: const Border(
          top: BorderSide(color: RetroTheme.win98Dark, width: 2),
          left: BorderSide(color: RetroTheme.win98Dark, width: 2),
          right: BorderSide(color: RetroTheme.win98Light, width: 2),
          bottom: BorderSide(color: RetroTheme.win98Light, width: 2),
        ),
        boxShadow: [
          BoxShadow(
            color: RetroTheme.bloodRed.withValues(alpha: 0.2),
            offset: const Offset(0, 0),
            blurRadius: 6,
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (hasUrl)
            Image.network(
              url,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.none,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  color: const Color(0xFF0A0000),
                  alignment: Alignment.center,
                  child: const Text(
                    'LOADING...',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: RetroTheme.bloodRed,
                    ),
                  ),
                );
              },
              errorBuilder: (_, __, ___) => _fallbackLabel(label),
            )
          else
            _fallbackLabel(label),
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              color: RetroTheme.accentBg,
              padding: const EdgeInsets.symmetric(
                  horizontal: RetroSpacing.xs, vertical: 2),
              child: Text(
                hasUrl ? 'GIF' : 'IMG',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                  fontSize: 10,
                  color: RetroTheme.bloodRed,
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              color: const Color(0x88000000),
              padding: const EdgeInsets.symmetric(
                  horizontal: RetroSpacing.xs, vertical: 2),
              child: const Text(
                '\u2620',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                  fontSize: 9,
                  color: RetroTheme.bloodRed,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallbackLabel(String text) {
    return Container(
      color: const Color(0xFF0A0000),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: RetroSpacing.sm),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: RetroTheme.boneWhite,
          fontWeight: FontWeight.w900,
          fontFamily: 'monospace',
          letterSpacing: 0.6,
          fontSize: 12,
        ),
      ),
    );
  }
}
