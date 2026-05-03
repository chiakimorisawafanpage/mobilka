import 'package:flutter/material.dart';

abstract final class RetroTheme {
  // --- GeoCities dark-space palette ---
  static const Color bg = Color(0xFF000033);
  static const Color panel = Color(0xFF0A0A2E);
  static const Color text = Color(0xFF00FF00);
  static const Color muted = Color(0xFF00CC99);
  static const Color border = Color(0xFF333399);
  static const Color link = Color(0xFFFF00FF);
  static const Color danger = Color(0xFFFF3333);
  static const Color accentBg = Color(0xFF330066);
  static const Color accentBlue = Color(0xFF00CCFF);
  static const Color accentPink = Color(0xFFFF69B4);
  static const Color accentYellow = Color(0xFFFFFF00);
  static const Color accentCyan = Color(0xFF00FFFF);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color win98Gray = Color(0xFFC0C0C0);
  static const Color win98Light = Color(0xFFDFDFDF);
  static const Color win98Dark = Color(0xFF808080);
  static const Color win98Darkest = Color(0xFF404040);
  static const Color starWhite = Color(0xFFFFFFFF);
}

abstract final class RetroSpacing {
  static const double xs = 6;
  static const double sm = 10;
  static const double md = 14;
  static const double lg = 18;
}

ThemeData buildRetroMaterialTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.transparent,
    colorScheme: ColorScheme.fromSeed(
      seedColor: RetroTheme.accentBlue,
      brightness: Brightness.dark,
      surface: RetroTheme.panel,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF110044),
      foregroundColor: RetroTheme.accentYellow,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: RetroTheme.accentYellow,
        fontSize: 18,
        fontWeight: FontWeight.w900,
        fontFamily: 'monospace',
        letterSpacing: 2.0,
        shadows: [
          Shadow(offset: Offset(2, 2), color: Color(0xFF000000), blurRadius: 0),
          Shadow(
              offset: Offset(-1, -1),
              color: Color(0xFFFF00FF),
              blurRadius: 4),
        ],
      ),
    ),
    dividerTheme: const DividerThemeData(
        color: RetroTheme.border, thickness: 2),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color(0xFF110044),
      contentTextStyle: TextStyle(
        color: RetroTheme.accentYellow,
        fontFamily: 'monospace',
        fontWeight: FontWeight.w700,
      ),
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: RetroTheme.bg,
      titleTextStyle: TextStyle(
        color: RetroTheme.accentYellow,
        fontWeight: FontWeight.w900,
        fontFamily: 'monospace',
        fontSize: 18,
      ),
      contentTextStyle: TextStyle(
        color: RetroTheme.text,
        fontFamily: 'monospace',
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: RetroTheme.accentBlue, width: 3),
        borderRadius: BorderRadius.zero,
      ),
    ),
  );
}

PreferredSizeWidget retroAppBarBottomBorder() {
  return const PreferredSize(
    preferredSize: Size.fromHeight(4),
    child: _RainbowBar(height: 4),
  );
}

AppBar retroAppBar(String title, {bool automaticallyImplyLeading = true}) {
  return AppBar(
    backgroundColor: const Color(0xFF110044),
    foregroundColor: RetroTheme.accentYellow,
    automaticallyImplyLeading: automaticallyImplyLeading,
    title: Text(
      '~ $title ~',
      style: const TextStyle(
        fontWeight: FontWeight.w900,
        fontFamily: 'monospace',
        letterSpacing: 2.0,
        color: RetroTheme.accentYellow,
        shadows: [
          Shadow(offset: Offset(2, 2), color: Color(0xFF000000), blurRadius: 0),
          Shadow(
              offset: Offset(-1, -1),
              color: Color(0xFFFF00FF),
              blurRadius: 4),
        ],
      ),
    ),
    bottom: retroAppBarBottomBorder(),
  );
}

class _RainbowBar extends StatelessWidget {
  const _RainbowBar({required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFF0000),
            Color(0xFFFF8800),
            Color(0xFFFFFF00),
            Color(0xFF00FF00),
            Color(0xFF00FFFF),
            Color(0xFF0000FF),
            Color(0xFFFF00FF),
          ],
        ),
      ),
    );
  }
}
