import 'package:flutter/material.dart';

abstract final class RetroTheme {
  // --- Gothic Horror palette ---
  static const Color bg = Color(0xFF000000);
  static const Color panel = Color(0xFF0D0D0D);
  static const Color text = Color(0xFFAAAAAA);
  static const Color muted = Color(0xFF666666);
  static const Color border = Color(0xFF333333);
  static const Color link = Color(0xFFCC0000);
  static const Color danger = Color(0xFFFF0000);
  static const Color accentBg = Color(0xFF1A0000);
  static const Color accentBlue = Color(0xFF444444);
  static const Color accentPink = Color(0xFFCC0000);
  static const Color accentYellow = Color(0xFFCC0000);
  static const Color accentCyan = Color(0xFF888888);
  static const Color silver = Color(0xFF999999);
  static const Color win98Gray = Color(0xFF555555);
  static const Color win98Light = Color(0xFF777777);
  static const Color win98Dark = Color(0xFF333333);
  static const Color win98Darkest = Color(0xFF1A1A1A);
  static const Color starWhite = Color(0xFFFFFFFF);
  static const Color bloodRed = Color(0xFFCC0000);
  static const Color darkRed = Color(0xFF660000);
  static const Color stoneGray = Color(0xFF555555);
  static const Color boneWhite = Color(0xFFDDCCBB);
  static const Color fireOrange = Color(0xFFFF6600);
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
      seedColor: RetroTheme.bloodRed,
      brightness: Brightness.dark,
      surface: RetroTheme.panel,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0A0000),
      foregroundColor: RetroTheme.bloodRed,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: RetroTheme.bloodRed,
        fontSize: 18,
        fontWeight: FontWeight.w900,
        fontFamily: 'monospace',
        letterSpacing: 2.0,
        shadows: [
          Shadow(
              offset: Offset(2, 2), color: Color(0xFF000000), blurRadius: 0),
          Shadow(
              offset: Offset(0, 0), color: Color(0xFFFF0000), blurRadius: 8),
        ],
      ),
    ),
    dividerTheme:
        const DividerThemeData(color: RetroTheme.border, thickness: 2),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color(0xFF1A0000),
      contentTextStyle: TextStyle(
        color: RetroTheme.bloodRed,
        fontFamily: 'monospace',
        fontWeight: FontWeight.w700,
      ),
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: RetroTheme.bg,
      titleTextStyle: TextStyle(
        color: RetroTheme.bloodRed,
        fontWeight: FontWeight.w900,
        fontFamily: 'monospace',
        fontSize: 18,
      ),
      contentTextStyle: TextStyle(
        color: RetroTheme.text,
        fontFamily: 'monospace',
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: RetroTheme.darkRed, width: 3),
        borderRadius: BorderRadius.zero,
      ),
    ),
  );
}

PreferredSizeWidget retroAppBarBottomBorder() {
  return const PreferredSize(
    preferredSize: Size.fromHeight(4),
    child: _BloodDrip(height: 4),
  );
}

AppBar retroAppBar(String title, {bool automaticallyImplyLeading = true}) {
  return AppBar(
    backgroundColor: const Color(0xFF0A0000),
    foregroundColor: RetroTheme.bloodRed,
    automaticallyImplyLeading: automaticallyImplyLeading,
    title: Text(
      '\u2620 $title \u2620',
      style: const TextStyle(
        fontWeight: FontWeight.w900,
        fontFamily: 'monospace',
        letterSpacing: 2.0,
        color: RetroTheme.bloodRed,
        shadows: [
          Shadow(
              offset: Offset(2, 2), color: Color(0xFF000000), blurRadius: 0),
          Shadow(
              offset: Offset(0, 0), color: Color(0xFFFF0000), blurRadius: 8),
        ],
      ),
    ),
    bottom: retroAppBarBottomBorder(),
  );
}

class _BloodDrip extends StatelessWidget {
  const _BloodDrip({required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF330000),
            Color(0xFFCC0000),
            Color(0xFF660000),
            Color(0xFFCC0000),
            Color(0xFF330000),
          ],
        ),
      ),
    );
  }
}
