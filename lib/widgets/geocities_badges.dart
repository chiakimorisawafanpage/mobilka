import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';

class GeocitiesHitCounter extends StatelessWidget {
  const GeocitiesHitCounter({super.key});

  @override
  Widget build(BuildContext context) {
    final count = (math.Random().nextInt(90000) + 10000).toString();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF000000),
        border: Border.all(color: RetroTheme.darkRed, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'SOULS CONSUMED: ',
            style: TextStyle(
              color: RetroTheme.silver,
              fontFamily: 'monospace',
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          ...count.split('').map(
                (d) => Container(
                  width: 14,
                  height: 18,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0000),
                    border: Border.all(
                        color: RetroTheme.darkRed.withValues(alpha: 0.5),
                        width: 1),
                  ),
                  child: Text(
                    d,
                    style: const TextStyle(
                      color: RetroTheme.bloodRed,
                      fontFamily: 'monospace',
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class GeocitiesUnderConstruction extends StatelessWidget {
  const GeocitiesUnderConstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0000),
        border: Border.all(color: RetroTheme.bloodRed, width: 2),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '\u2620 ',
            style: TextStyle(fontSize: 16, color: RetroTheme.bloodRed),
          ),
          Text(
            'ENTER AT YOUR OWN RISK',
            style: TextStyle(
              fontFamily: 'monospace',
              fontWeight: FontWeight.w900,
              fontSize: 11,
              color: RetroTheme.bloodRed,
            ),
          ),
          Text(
            ' \u2620',
            style: TextStyle(fontSize: 16, color: RetroTheme.bloodRed),
          ),
        ],
      ),
    );
  }
}

class GeocitiesBestViewed extends StatelessWidget {
  const GeocitiesBestViewed({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF000000),
        border: Border.all(
            color: RetroTheme.border.withValues(alpha: 0.5), width: 1),
      ),
      child: const Text(
        'Best viewed in the dark\nat 800x600 resolution',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 9,
          color: RetroTheme.silver,
          height: 1.4,
        ),
      ),
    );
  }
}

class GeocitiesGuestbook extends StatelessWidget {
  const GeocitiesGuestbook({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0000),
        border: Border.all(color: RetroTheme.darkRed, width: 2),
      ),
      child: const Text(
        '\u270F Sign the Book of Shadows \u270F',
        style: TextStyle(
          fontFamily: 'monospace',
          fontWeight: FontWeight.w700,
          fontSize: 11,
          color: RetroTheme.bloodRed,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

class GeocitiesWebring extends StatelessWidget {
  const GeocitiesWebring({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF000000),
        border: Border.all(color: RetroTheme.darkRed, width: 1),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '<< prev',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 10,
              color: RetroTheme.bloodRed,
              decoration: TextDecoration.underline,
            ),
          ),
          Text(
            ' | DARK WEBRING | ',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: RetroTheme.silver,
            ),
          ),
          Text(
            'next >>',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 10,
              color: RetroTheme.bloodRed,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}
