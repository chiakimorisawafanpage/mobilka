import 'package:flutter/material.dart';

import '../theme.dart';

/// «Фото» товара: по возможности GIF из сети, иначе белая заглушка с подписью.
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
        color: const Color(0xFFFFFFFF),
        border: Border.all(color: RetroTheme.border, width: 2),
        boxShadow: const [
          BoxShadow(
              color: Color(0x66000000), offset: Offset(2, 2), blurRadius: 0),
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
                  color: const Color(0xFFE8E8E8),
                  alignment: Alignment.center,
                  child: const Text(
                    'LOADING…',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11),
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
                style:
                    const TextStyle(fontWeight: FontWeight.w900, fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallbackLabel(String text) {
    return Container(
      color: const Color(0xFFFFFFFF),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: RetroSpacing.sm),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: RetroTheme.muted,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.6,
          fontSize: 12,
        ),
      ),
    );
  }
}
