import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';

class GeocitiesHitCounter extends StatelessWidget {
  const GeocitiesHitCounter({super.key});

  @override
  Widget build(BuildContext context) {
    final count = (math.Random(42).nextInt(90000) + 10000).toString();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: RetroTheme.win98Gray,
        borderRadius: BorderRadius.circular(2),
        border: const Border(
          top: BorderSide(color: RetroTheme.win98Dark, width: 1),
          left: BorderSide(color: RetroTheme.win98Dark, width: 1),
          right: BorderSide(color: RetroTheme.win98Light, width: 1),
          bottom: BorderSide(color: RetroTheme.win98Light, width: 1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Visitors: ',
            style: TextStyle(
              color: RetroTheme.text,
              fontFamily: 'monospace',
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          ...count.characters.map((ch) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: RetroTheme.border, width: 1),
                  borderRadius: BorderRadius.circular(1),
                ),
                child: Text(
                  ch,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                    color: RetroTheme.text,
                  ),
                ),
              )),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E0),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: RetroTheme.accentYellow, width: 1),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.construction, size: 14, color: RetroTheme.accentYellow),
          SizedBox(width: 6),
          Text(
            'Under Construction',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontFamily: 'monospace',
              color: Color(0xFF886600),
              fontSize: 10,
            ),
          ),
          SizedBox(width: 6),
          Icon(Icons.construction, size: 14, color: RetroTheme.accentYellow),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: RetroTheme.win98Gray,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: RetroTheme.border, width: 1),
      ),
      child: const Text(
        'Best viewed at 800x600 resolution',
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 9,
          color: RetroTheme.muted,
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: RetroTheme.panel,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: RetroTheme.accentBlue, width: 1),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.edit_note, size: 14, color: RetroTheme.accentBlue),
          SizedBox(width: 6),
          Text(
            'Sign my Guestbook',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'monospace',
              color: RetroTheme.accentBlue,
              fontSize: 10,
              decoration: TextDecoration.underline,
              decorationColor: RetroTheme.accentBlue,
            ),
          ),
        ],
      ),
    );
  }
}

class GeocitiesWebring extends StatelessWidget {
  const GeocitiesWebring({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: RetroTheme.win98Gray,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: RetroTheme.border, width: 1),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '[\u25C0 prev]',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: RetroTheme.link,
            ),
          ),
          SizedBox(width: 6),
          Text(
            'Energy Webring',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: RetroTheme.text,
            ),
          ),
          SizedBox(width: 6),
          Text(
            '[next \u25B6]',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: RetroTheme.link,
            ),
          ),
        ],
      ),
    );
  }
}
