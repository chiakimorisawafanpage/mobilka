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
        border: Border.all(color: RetroTheme.accentCyan, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'VISITORS: ',
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
                    color: const Color(0xFF001100),
                    border: Border.all(
                        color: RetroTheme.text.withValues(alpha: 0.5),
                        width: 1),
                  ),
                  child: Text(
                    d,
                    style: const TextStyle(
                      color: RetroTheme.text,
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
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFF00), Color(0xFF000000)],
          stops: [0.0, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          tileMode: TileMode.repeated,
        ),
        border: Border.all(color: RetroTheme.accentYellow, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '\u26A0 ',
            style: TextStyle(fontSize: 16, color: RetroTheme.accentYellow),
          ),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w900,
                fontSize: 11,
              ),
              children: [
                TextSpan(
                  text: 'UNDER ',
                  style: TextStyle(color: Color(0xFF000000)),
                ),
                TextSpan(
                  text: 'CONSTRUCTION',
                  style: TextStyle(color: Color(0xFFFF0000)),
                ),
              ],
            ),
          ),
          const Text(
            ' \u26A0',
            style: TextStyle(fontSize: 16, color: RetroTheme.accentYellow),
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
        'Best viewed in Netscape Navigator 4.0\nat 800x600 resolution',
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
        color: const Color(0xFF000033),
        border: Border.all(color: RetroTheme.link, width: 2),
      ),
      child: const Text(
        '\u270F Sign my Guestbook! \u270F',
        style: TextStyle(
          fontFamily: 'monospace',
          fontWeight: FontWeight.w700,
          fontSize: 11,
          color: RetroTheme.link,
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
        border: Border.all(color: RetroTheme.accentBlue, width: 1),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '<< prev',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 10,
              color: RetroTheme.accentCyan,
              decoration: TextDecoration.underline,
            ),
          ),
          Text(
            ' | ENERGY WEBRING | ',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: RetroTheme.accentYellow,
            ),
          ),
          Text(
            'next >>',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 10,
              color: RetroTheme.accentCyan,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}
